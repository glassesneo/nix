--- lua_source {{{
require("ddc_source_lsp_setup").setup({
  override_capabilities = true,
  respect_trigger = true,
})

local lspconfig = require("lspconfig")

lspconfig.nil_ls.setup({})

lspconfig.marksman.setup({})

lspconfig.denols.setup({
  root_dir = lspconfig.util.root_pattern("deno.json"),
  init_options = {
    lint = true,
    unstable = true,
    suggest = {
      imports = {
        hosts = {
          ["https://deno.land"] = true,
          ["https://cdn.nest.land"] = true,
          ["https://crux.land"] = true,
        },
      },
    },
  },
})

lspconfig.ts_ls.setup({
  root_dir = lspconfig.util.root_pattern("package.json"),
})

lspconfig.svelte.setup({})

lspconfig.nim_langserver.setup({})

-- lspconfig.efm.setup({
--   init_options = {
--     documentFormatting = true,
--     documentRangeFormatting = true,
--   },
--   settings = {
--     rootMarkers = {
--       ".git/",
--     },
--     languages = {},
--   },
--   filetypes = {},
-- })

lspconfig.jsonls.setup({})

lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        pathStrict = true,
        path = { "?.lua", "?/init.lua" },
      },
      workspace = {
        library = vim.list_extend(vim.api.nvim_get_runtime_file("lua", true), {
          "${3rd}/luv/library",
          "${3rd}/busted/library",
          "${3rd}/luassert/library",
        }),
        checkThirdParty = false,
      },
    },
  },
})

lspconfig.elmls.setup({})

lspconfig.typst_lsp.setup({})

vim.diagnostic.config({ severity_sort = true })

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  update_in_insert = false,
  virtual_text = {
    format = function(diagnostic)
      return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
    end,
  },
})
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})
--- }}}
