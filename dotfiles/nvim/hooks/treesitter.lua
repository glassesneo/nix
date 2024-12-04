--- lua_source {{{
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "css",
    "elm",
    "gitignore",
    "haskell",
    "html",
    "lua",
    "nim",
    "nim_format_string",
    "nix",
    "toml",
    "svelte",
    "v",
    "zig",
  },
  sync_install = true,
  auto_install = false,
  ignore_install = { "all" },
  injection = {
    enable = true,
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  modules = {
    autotag = {
      enable = true,
      filetypes = {
        "html",
        "svelte",
        "typescript",
      },
    },
  },
})
--- }}}
