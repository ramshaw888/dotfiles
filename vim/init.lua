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

-- Keymaps
local bufopts = { noremap = true, silent = true }
vim.keymap.set("n", "<C-f>", builtin.git_files, bufopts)
vim.keymap.set("n", "<C-y>", repositories, bufopts)
vim.keymap.set("n", "<C-t>", pgcli_history, bufopts)
vim.keymap.set("n", "<C-s>", builtin.live_grep, bufopts)

local on_attach = function(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>ff', vim.lsp.buf.formatting, bufopts)
  vim.keymap.set("n", "<Space>", builtin.lsp_document_symbols, bufopts)
  vim.keymap.set("n", "<leader>g", builtin.lsp_definitions, bufopts)
  vim.keymap.set("n", "<leader>f", builtin.lsp_references, bufopts)
  vim.keymap.set("n", "gi", builtin.lsp_implementations, bufopts)
  vim.keymap.set("n", "gy", builtin.lsp_type_definitions, bufopts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
  vim.keymap.set({ "n", "x", "v" }, "<leader>ac", vim.lsp.buf.code_action, bufopts)
end

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

for _, lsp in pairs({ 'gopls', 'tsserver', 'terraformls', 'tflint', 'yamlls', 'pyright', 'sumneko_lua' }) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
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
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = "vsnip" },
  },
}

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = vim.lsp.buf.formatting_seq_sync,
})

function startswith(text, prefix)
  return text:find(prefix, 1, true) == 1
end
