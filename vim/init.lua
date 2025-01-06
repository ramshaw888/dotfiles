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
local prettierd = require("efmls-configs.formatters.prettier_d")

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

require("copilot_cmp").setup()

-- Keymaps
local bufopts = { noremap = true, silent = true }
vim.keymap.set("n", "<C-f>", builtin.git_files, bufopts)
vim.keymap.set("n", "<C-y>", repositories, bufopts)
vim.keymap.set("n", "<C-t>", pgcli_history, bufopts)
vim.keymap.set("n", "<C-s>", builtin.live_grep, bufopts)

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)

-- Add a new keymap to expand current line's diagnostics into a split
vim.keymap.set('n', '<leader>de', function()
    -- Get diagnostics for current line
    local diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })

    -- Create new split
    vim.cmd('botright split')
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, buf)

    -- Format and insert diagnostics
    local lines = {}
    for _, d in ipairs(diagnostics) do
        -- Split message on newlines and add each line
        local message_lines = vim.split(d.message, '\n', true)
        local source = d.source and ('(' .. d.source .. ')') or ''

        -- Add first line with severity and source
        table.insert(lines, string.format("[%s] %s %s", d.severity, message_lines[1], source))

        -- Add remaining lines indented
        for i = 2, #message_lines do
            table.insert(lines, "    " .. message_lines[i])
        end

        -- If there's detailed related information, add it
        if d.relatedInformation then
            for _, info in ipairs(d.relatedInformation) do
                local info_lines = vim.split(info.message, '\n', true)
                for _, line in ipairs(info_lines) do
                    table.insert(lines, '  → ' .. line)
                end
            end
        end

        -- Add a blank line between different diagnostics
        table.insert(lines, "")
    end

    -- Set lines in buffer
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- Make it non-modifiable
    vim.bo[buf].modifiable = false
    vim.bo[buf].buftype = 'nofile'
    vim.bo[buf].filetype = 'DiagnosticExpand'
end, bufopts)

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

for _, lsp in pairs({ 'gopls', 'tflint', 'yamlls', 'pyright', 'lua_ls', 'graphql' }) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

local ts_ls_settings = {
  inlayHints = {
    includeInlayParameterNameHints = "all",
    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
    includeInlayFunctionParameterTypeHints = true,
    includeInlayVariableTypeHints = true,
    includeInlayVariableTypeHintsWhenTypeMatchesName = true,
    includeInlayPropertyDeclarationTypeHints = true,
    includeInlayFunctionLikeReturnTypeHints = true,
    includeInlayEnumMemberValueHints = true,
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
})

lspconfig.efm.setup({
  init_options = {
    documentFormatting = true,
  },
  settings = {
    languages = {
      graphql = { prettierd },
      jsonc = { prettierd },
      json = { prettierd },
      html = { prettierd },
      typescriptreact = { prettierd },
      typescript = { prettierd },
      markdown = { prettierd },
      javascript = { prettierd },
    },
  },
})

vim.diagnostic.config({
  float = {
    border = "rounded",
    source = true,
    width = 120,
    max_width = 500,
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
    { name = "copilot" },
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
