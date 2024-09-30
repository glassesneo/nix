--- lua_source {{{
require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "nim", "toml" },
  sync_install = true,
  auto_install = false,
  ignore_install = { "all" },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
})
--- }}}
