vim.cmd("source $HOME/.dotfiles/vim/config.vim")

require'nvim-treesitter.configs'.setup {
  highlight = { enable = true },
}

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

function _G.repositories(opts)
  opts = opts or {}

  local results = {}
  for i in string.gmatch(vim.call("UserCall", "lsrepos"), "%S+") do
    table.insert(results, i)
  end

  pickers.new(opts, {
    prompt_title = "repositories",

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
        local cwd = action_state.get_current_picker(prompt_bufnr).cwd
        local selection = action_state.get_selected_entry()
        if selection == nil then
          utils.__warn_no_selection "actions.repositories"
          return
        end
        actions.close(prompt_bufnr)
        vim.call("ChangeDir", selection.value)
      end)
      return true
    end,

    sorter = conf.generic_sorter(opts),
    previewer = conf.file_previewer(opts),
    theme = "dropdown",
  }):find()
end

require('telescope').setup{
  defaults = {
    theme = "dropdown"
  },
  pickers = {
    git_files = { theme = "dropdown" },
    live_grep = { theme = "dropdown" },
    repositories = { theme = "dropdown" },
  },
}
