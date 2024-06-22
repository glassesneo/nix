--- lua_source {{{
require("git").setup({
  default_mappings = true, -- NOTE: `quit_blame` and `blame_commit` are still merged to the keymaps even if `default_mappings = false`

  keymaps = {},
  -- Default target branch when create a pull request
  target_branch = "main",
  -- Enable winbar in all windows created by this plugin
  winbar = false,
})
--- }}}
