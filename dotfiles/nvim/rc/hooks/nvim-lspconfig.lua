--- lua_source {{{
local lspconfig = require("lspconfig")
local capabilities = require("ddc_source_lsp").make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.nil_ls.setup({
  capabilities = capabilities,
})

lspconfig.marksman.setup({
  capabilities = capabilities,
})

lspconfig.nim_langserver.setup({
  capabilities = capabilities,
})

lspconfig.efm.setup({
  capabilities = capabilities,
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
  },
  settings = {
    rootMarkers = {
      ".git/",
    },
    languages = {},
  },
  filetypes = {},
})

lspconfig.denols.setup({
  capabilities = capabilities,
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

lspconfig.tsserver.setup({
  capabilities = capabilities,
  root_dir = lspconfig.util.root_pattern("package.json"),
})

lspconfig.jsonls.setup({
  capabilities = capabilities,
})

lspconfig.lua_ls.setup({
  capabilities = capabilities,
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

lspconfig.elmls.setup({
  capabilities = capabilities,
})

lspconfig.typst_lsp.setup({
  capabilities = capabilities,
})

lspconfig.v_analyzer.setup({
  capabilities = capabilities,
})

local lsp_signature = require("lsp_signature")

lsp_signature.setup({
  bind = true,
  handler_opts = {
    border = "rounded",
  },
})

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
