--- lua_source {{{
require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "nim", "toml", "typescript" },
  sync_install = true,
  auto_install = false,
  ignore_install = {},
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  -- textsubjects = {
  --   enable = true,
  --   prev_selection = ",", -- (Optional) keymap to select the previous selection
  --   keymaps = {
  --     ["."] = "textsubjects-smart",
  --     [";"] = "textsubjects-container-outer",
  --     ["i;"] = { "textsubjects-container-inner", desc = "Select inside containers (classes, functions, etc.)" },
  --   },
  -- },
})
--- }}}
