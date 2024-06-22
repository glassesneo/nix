--- lua_add {{{
local utils = require("utils")

require("oil").setup({
  -- default_file_explorer = true,
  column = {
    "icon",
    "permissions",
  },
  delete_to_trash = true,
  skip_confirm_for_simple_edits = true,
  keymaps = {
    ["<CR>"] = "actions.select",
    ["<C-t>"] = "actions.select_tab",
    ["<C-s>"] = "actions.select_split",
    ["<C-v>"] = "actions.select_vsplit",
    ["<C-p>"] = "actions.preview",
    ["<BS>"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["q"] = "actions.close",
  },
  use_default_keymaps = false,
  view_options = {
    show_hidden = true,
    is_always_hidden = function(name, _)
      return name == ".DS_Store"
    end,
  },
  float = {
    padding = 12,
    max_width = 70,
    max_height = 25,
  },
})
-- utils.map("n", "<Space><Space>", "<Cmd>Oil --float<CR>")
-- utils.map("n", "-", "<Cmd>Oil<CR>")
--- }}}
