--- lua_source {{{
require("ts_context_commentstring").setup({
  enable_autocmd = false,
  languages = {
    nim = "# %s",
    toml = "# %s",
    nix = "# %s",
  },
})
--- }}}
