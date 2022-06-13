vim.cmd("source $HOME/.dotfiles/vim/config.vim")

local telescope = require "telescope"
local pickers = require "telescope.pickers"
local builtin = require "telescope.builtin"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local lspconfig = require 'lspconfig'
local cmp = require 'cmp'

require'nvim-treesitter.configs'.setup {
  highlight = { enable = true },
}

function _G.repositories(opts)
  opts = opts or {}
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

telescope.setup{
  pickers = {
    git_files = { theme = "dropdown" },
    live_grep = { theme = "dropdown" },
  },
}

-- Keymaps
local bufopts = { noremap = true, silent = true }
vim.keymap.set("n", "<C-f>", builtin.git_files, bufopts)
vim.keymap.set("n", "<C-y>", repositories, bufopts)
vim.keymap.set("n", "<C-s>", builtin.live_grep, bufopts)

local on_attach = function(client, bufnr)
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>ff', vim.lsp.buf.formatting, bufopts)
  vim.keymap.set("n", "<Space>", builtin.lsp_document_symbols, bufopts)
  vim.keymap.set("n", "<leader>g", builtin.lsp_definitions, bufopts)
  vim.keymap.set("n", "<leader>f", builtin.lsp_references, bufopts)
  vim.keymap.set("n", "gi", builtin.lsp_implementations, bufopts)
  vim.keymap.set("n", "gy", builtin.lsp_type_definitions, bufopts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
  vim.keymap.set({ "n", "x" }, "<leader>ac", ":CodeActionMenu <CR>", bufopts)
end

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

for _, lsp in pairs({ 'gopls', 'tsserver' }) do
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
