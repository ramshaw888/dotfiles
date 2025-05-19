vim.loader.enable()  -- Enable native loader for faster startups

vim.cmd("source $HOME/.dotfiles/vim/config.vim")

local pickers = require "telescope.pickers"
local builtin = require "telescope.builtin"
local finders = require "telescope.finders"
local previewers = require "telescope.previewers"
local layout_strategies = require "telescope.pickers.layout_strategies"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local lspconfig = require 'lspconfig'
local cmp = require 'cmp'
local biome = require("efmls-configs.formatters.biome")
require 'lsp_timing'

require 'nvim-treesitter.configs'.setup {
  highlight = { enable = true },
}

function _G.repositories(opts)
  opts = opts or {}
  opts.layout_strategy = "center"

  local results = {}
  for i in string.gmatch(vim.call("UserCall", "lsrepos"), "%S+") do
    table.insert(results, i)
  end

  pickers.new(opts, {
    prompt_title = "repositories",
    sorter = conf.generic_sorter(opts),
    previewer = conf.file_previewer(opts),
    finder = finders.new_table {
      results = results,
      entry_maker = function(entry)
        return {
          value = entry,
          filename = os.getenv("CODEDIR") .. "/" .. entry .. "/readme.md",
          display = entry,
          ordinal = entry,
        }
      end,
    },
    attach_mappings = function(_, map)
      actions.select_default:replace(function(prompt_bufnr)
        actions.close(prompt_bufnr)
        vim.call("ChangeDir", action_state.get_selected_entry().value)
      end)
      return true
    end,
  }):find()
end

function _G.pgcli_history(opts)
  opts = opts or {}
  opts.layout_strategy = "vertical"

  local results = {}
  local timestamps = {}
  local timestamp = ""
  for i in string.gmatch(vim.call("UserCall", "tail -n 10000 $HOME/.config/pgcli/history"), "[^\r\n]+") do
    if startswith(i, "#") then
      timestamp = i:sub(3)
      results[timestamp] = {}
      table.insert(timestamps, timestamp)
    else
      if results[timestamp] ~= nil then
        table.insert(results[timestamp], i:sub(2))
      end
    end
  end

  pickers.new(opts, {
    prompt_title = "history",
    sorter = conf.generic_sorter(opts),

    previewer = previewers.new_buffer_previewer {
      title = "pgcli history",
      dyn_title = function(_, entry)
        return entry.value
      end,

      get_buffer_by_name = function(_, entry)
        return entry.value
      end,

      define_preview = function(self, entry)
        if self.state.bufname then
          return
        end

        local items = results[entry.value]
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, items)
        require('telescope.previewers.utils').regex_highlighter(self.state.bufnr, 'sql')
      end,
    },

    finder = finders.new_table {
      results = timestamps,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry,
          ordinal = entry,
        }
      end,
    },
    attach_mappings = function(_, map)
      actions.select_default:replace(function(prompt_bufnr)
        actions.close(prompt_bufnr)

        local items = results[action_state.get_selected_entry().value]

        for k, v in pairs(items) do
          vim.cmd 'normal o'
          vim.api.nvim_set_current_line(v)
        end

      end)
      return true
    end,
  }):find()
end

require('telescope').setup({
  defaults = {
    layout_strategy = 'center',
    layout_config = { height = 0.95 },
    path_display = { 'truncate' }
  },
  vimgrep_arguments = {
    'rg', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case', '-C', '10'
  },
  pickers = {
    git_files = {
      theme = "dropdown",
      layout_config = { center = { width = 0.8 } },
    },
    live_grep = {
      theme = "dropdown",
      layout_config = { center = { width = 0.8 } },
    },
    lsp_references = {
      theme = "dropdown",
      show_line = true,
      layout_config = {
        center = { width = 0.9 },
      },
    },
    lsp_document_symbols = {
      show_line = true,
      theme = "dropdown",
      layout_config = {
        center = { width = 0.8 },
      },
    },
  },
})

require("telescope").load_extension("ui-select") -- for code actions dropdowns

-- Disable default copilot plugin in favour of copilot-cmp
--require("copilot").setup({
--  suggestion = { enabled = false },
--  panel = { enabled = false },
--})

--require("copilot").setup({
--  suggestion = { enabled = false },
--  panel = { enabled = false },
--})
--require("copilot_cmp").setup()

-- Keymaps
local bufopts = { noremap = true, silent = true }
vim.keymap.set("n", "<C-f>", function()
  builtin.git_files({ show_untracked = true })
end, bufopts)
vim.keymap.set("n", "<C-p>", builtin.git_status, bufopts)
vim.keymap.set("n", "<C-y>", repositories, bufopts)
vim.keymap.set("n", "<C-t>", pgcli_history, bufopts)
vim.keymap.set("n", "<C-s>", builtin.live_grep, bufopts)

vim.keymap.set('n', 't[', vim.diagnostic.goto_prev, bufopts)
vim.keymap.set('n', 't]', vim.diagnostic.goto_next, bufopts)

require('trouble').setup()
vim.keymap.set('n', '[st', '<cmd>Trouble diagnostics<cr>', bufopts)

local on_attach = function(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>ff', vim.lsp.buf.format, bufopts)
  vim.keymap.set("n", "<Space>", builtin.lsp_document_symbols, bufopts)
  vim.keymap.set("n", "<leader>g", builtin.lsp_definitions, bufopts)
  vim.keymap.set("n", "<leader>f", builtin.lsp_references, bufopts)
  vim.keymap.set("n", "gi", builtin.lsp_implementations, bufopts)
  vim.keymap.set("n", "gy", builtin.lsp_type_definitions, bufopts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
  vim.keymap.set({ "n", "x", "v" }, "<leader>ac", vim.lsp.buf.code_action, bufopts)
end

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

for _, lsp in pairs({ 'gopls', 'tflint', 'yamlls', 'pyright', 'lua_ls' }) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- GraphQL language server with specific file extension support
lspconfig.graphql.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "graphql", "typescriptreact", "javascriptreact" },
  root_dir = lspconfig.util.root_pattern('.graphqlrc*', '.graphql.config.*', 'graphql.config.*'),
  cmd = { "graphql-lsp", "server", "-m", "stream" }
}

local ts_ls_settings = {
 inlayHints = {
   -- Controls parameter name hints display
   -- "literals": only shows for literal arguments (strings, numbers, etc.)
   -- "all": shows for all arguments
   -- "none": disables parameter name hints
   includeInlayParameterNameHints = "literals",

   -- When true, shows parameter name hints even when the argument
   -- variable name is identical to the parameter name
   includeInlayParameterNameHintsWhenArgumentMatchesName = false,

   -- Displays the type of parameters in function calls
   -- e.g., function(param: string)
   includeInlayFunctionParameterTypeHints = true,

   -- Shows inferred types for variables
   -- e.g., const x: number = 5
   includeInlayVariableTypeHints = false,

   -- Shows variable type hints even when the variable name
   -- suggests its type (e.g., showing `: string` for `userName`)
   includeInlayVariableTypeHintsWhenTypeMatchesName = false,

   -- Shows inferred types for property declarations in objects and classes
   -- e.g., class { prop: number; }
   includeInlayPropertyDeclarationTypeHints = false,

   -- Displays return types for functions where they aren't explicitly specified
   -- e.g., function(): string { return "hello" }
   includeInlayFunctionLikeReturnTypeHints = true,

   -- Shows the numeric values of enum members inline with their definitions
   -- e.g., enum Color { Red = 0, Green = 1 }
   includeInlayEnumMemberValueHints = false,

   -- When false, doesn't automatically offer completions for exports from modules
   -- (can reduce noise in autocomplete suggestions)
   includeCompletionsForModuleExports = false,
 },
}

lspconfig.ts_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    typescript = ts_ls_settings,
    javascript = ts_ls_settings,
  },
  init_options = {
    maxTsServerMemory = 4096,
    tsserver = {
      logVerbosity = "off",
      useSyntaxServer = "auto"
    }
  },
  flags = {
    debounce_text_changes = 150,
  }
})

lspconfig.efm.setup({
  init_options = {
    documentFormatting = true,
  },
  settings = {
    languages = {
      graphql = { biome },
      jsonc = { biome },
      json = { biome },
      html = { biome },
      typescriptreact = { biome },
      typescript = { biome },
      markdown = { biome },
      javascript = { biome },
      javascriptreact = { biome },
    },
  },
})

vim.diagnostic.config({
  float = {
    border = "rounded",
    source = true,
    width = 120,
    max_width = 800,
    max_height = 100,
    wrap = true,
    style = "minimal",
  },
})

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end

cmp.setup {
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ["<Tab>"] = vim.schedule_wrap(function(fallback)
      if cmp.visible() and has_words_before() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end),
  }),
  sources = {
    --{ name = "copilot" },
    { name = 'nvim_lsp' },
    { name = "vsnip" },
  },
}

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.lsp.buf.format({
      buffer = vim.api.nvim_get_current_buf(),
      filter = function(client)
        return client.name ~= "tsserver" and client.name ~= "eslint"
      end,
    })
  end,
})

function startswith(text, prefix)
  return text:find(prefix, 1, true) == 1
end

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- Reset problematic highlight groups to use gruvbox colors
    vim.api.nvim_set_hl(0, "NormalFloat", { link = "GruvboxYellowSign" })
    vim.api.nvim_set_hl(0, "FloatBorder", { link = "GruvboxYellowSign" })
  end,
})

vim.opt.termguicolors = true
vim.opt.background = 'light' -- or dark
vim.g.gruvbox_contrast_light = 'medium'
vim.cmd.colorscheme('gruvbox')
