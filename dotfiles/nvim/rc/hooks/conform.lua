--- lua_source {{{
require("conform").setup({
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
  formatters_by_ft = {
    lua = { "stylua" },
    nim = { "nimpretty" },
    elm = { "elm-format" },
    toml = { "taplo" },
    nix = { "nixpkgs-fmt" },
  },
  formatters = {
    stylua = {
      command = "stylua",
      prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
    },
    taplo = {
      command = "taplo",
      prepend_args = { "format", "--stdin-filepath" },
    },
    nixfmt = {
      command = "nixpkgs-fmt",
      args = "$FILENAME",
    },
  },
})
--- }}}

--- lua_source {{{
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})
--- }}}
