--- lua_source {{{
local lspconfig = require("lspconfig")

require("lsp-format").setup({})

---@param client vim.lsp.Client
---@param bufnr? number
local lspformat_on_attach = function(client, bufnr)
  require("lsp-format").on_attach(client, bufnr)
end

local servers = {
  denols = {
    single_file_support = true,
    root_dir = lspconfig.util.root_pattern("deno.json"),
    settings = {
      deno = {
        inlayHints = {
          parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = true },
          parameterTypes = { enabled = true },
          variableTypes = { enabled = true, suppressWhenTypeMatchesName = true },
          propertyDeclarationTypes = { enabled = true },
          functionLikeReturnTypes = { enable = true },
          enumMemberValues = { enabled = true },
        },
      },
    },
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
  },
  elmls = {
    root_dir = lspconfig.util.root_pattern("elm.json"),
  },
  gopls = {},
  -- hls = {},
  kotlin_language_server = {
    settings = {
      kotlin = {
        compiler = {
          jvm = {
            target = "21",
          },
        },
        hints = {
          typeHints = true,
          parameterHints = true,
          chaineHints = true,
        },
      },
    },
  },
  lua_ls = {
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
        hint = {
          enable = true,
        },
      },
    },
  },
  marksman = {},
  metals = {},
  nil_ls = {
    settings = {
      flake = {
        autoArchive = true,
      },
    },
  },
  pylyzer = {
    settings = {
      python = {
        inlayHints = true,
      },
    },
  },
  sqlls = {},
  svelte = {
    on_attach = lspformat_on_attach,
    settings = {
      typescript = {
        inlayHints = {
          parameterNames = { enabled = "all" },
          parameterTypes = { enabled = true },
          variableTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          enumMemberValues = { enabled = true },
        },
      },
    },
  },
  taplo = {},
  ts_ls = {
    root_dir = lspconfig.util.root_pattern("package.json"),
    single_file_support = false,
    settings = {
      typescript = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
  v_analyzer = {},
  zls = {
    settings = {
      zls = {
        enable_inlay_hints = true,
        inlay_hints_show_builtin = true,
        inlay_hints_exclude_single_argument = true,
        inlay_hints_hide_redundant_param_names = false,
        inlay_hints_hide_redundant_param_names_last_token = false,
      },
    },
  },
}

for lsp, config in pairs(servers) do
  lspconfig[lsp].setup(config)
end
--- }}}
