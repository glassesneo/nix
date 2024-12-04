--- lua_source {{{
local utils = require("utils")
local luasnip = require("luasnip")

local commonSources = {
  "around",
  "rg",
  "file",
  -- "skkeleton",
}

local commonLangSources = utils.array_concat_unique({
  "lsp",
  -- "treesitter",
}, commonSources)

local headMatchers = {
  "matcher_head",
  "matcher_prefix",
}

local commonConverters = {
  "converter_truncate_abbr",
  "converter_remove_overlap",
}

local fuzzyConverters = utils.array_concat_unique({
  "converter_fuzzy",
}, commonConverters)

vim.fn["ddc#custom#patch_global"]({
  ui = "pum",
  sources = commonSources,
  autoCompleteEvents = {
    "InsertEnter",
    "TextChangedI",
    "TextChangedP",
    "TextChangedT",
    "CmdlineEnter",
    "CmdlineChanged",
  },
  cmdlineSources = {
    [":"] = {
      "file",
      "cmdline",
      "cmdline-history",
      "around",
    },
    ["/"] = commonSources,
  },
  sourceOptions = {
    ["_"] = {
      matchers = headMatchers,
      sorters = { "sorter_rank" },
      converters = commonConverters,
      minAutoCompleteLength = 3,
      ignoreCase = true,
    },
    around = {
      mark = "[around]",
      matchers = {
        "matcher_fuzzy",
      },
      sorters = {
        "sorter_fuzzy",
      },
      converters = fuzzyConverters,
      minAutoCompleteLength = 3,
      maxAutoCompleteLength = 5,
    },
    buffer = {
      mark = "[buf]",
      matchers = {
        "matcher_fuzzy",
      },
      sorters = {
        "sorter_fuzzy",
      },
      converters = fuzzyConverters,
    },
    cmdline = {
      mark = "[>_]",
      forceCompletionPattern = [[\S/\S*|\.\w*]],
      minAutoCompleteLength = 1,
    },
    ["cmdline-history"] = {
      mark = "[>_ his]",
      sorters = {},
      minAutoCompleteLength = 1,
    },
    file = {
      mark = "[file]",
      forceCompletionPattern = [[\S/\S*]],
      isVolatile = true,
    },
    line = {
      mark = "[line]",
      matchers = {
        "matcher_fuzzy",
      },
      sorters = {
        "sorter_fuzzy",
      },
      converters = fuzzyConverters,
    },
    lsp = {
      mark = "[LSP]",
      sorters = {
        "sorter_lsp-kind",
      },
      converters = utils.array_concat_unique({
        "converter_kind_labels",
      }, commonConverters),
      dup = true,
    },
    ["nvim-lua"] = {
      mark = "[lua]",
      matchers = {
        "matcher_fuzzy",
      },
      sorters = {
        "sorter_fuzzy",
      },
      converters = fuzzyConverters,
      forceCompletionPattern = [[\.\w*]],
    },
    -- path = {
    --   mark = "[path]",
    --   forceCompletionPattern = [[\S/\S*]],
    --   isVolatile = true,
    -- },
    rg = {
      mark = "[rg]",
      matchers = {
        "matcher_fuzzy",
      },
      sorters = {
        "sorter_fuzzy",
      },
      converters = fuzzyConverters,
      minAutoCompleteLength = 6,
    },
    skkeleton = {
      mark = "[SKK]",
      matchers = {},
      sorters = {},
      converters = {},
      isVolatile = true,
      minAutoCompleteLength = 1,
    },
    treesitter = {
      mark = "[TS]",
      matchers = {
        "matcher_fuzzy",
      },
      sorters = {
        "sorter_fuzzy",
      },
      converters = fuzzyConverters,
      minAutoCompleteLength = 6,
    },
  },
  sourceParams = {
    buffer = {
      limitBytes = 5000000,
      forceCollect = true,
    },
    lsp = {
      enableAdditionalTextEdit = true,
      enableDisplayDetail = true,
      enableResolveItem = true,
      lspEngine = "nvim-lsp",
      snippetEngine = vim.fn["denops#callback#register"](function(body)
        luasnip.lsp_expand(body)
      end),
    },
    -- path = {
    --   cmd = { "fd", "--max-depth", "5" },
    -- },
  },
  postFilters = {
    "postfilter_score",
  },
  filterParams = {
    converter_fuzzy = {
      hlGroup = "Title",
    },
    postfilter_score = {
      hlGroup = "",
      -- showScore = true,
    },
    converter_kind_labels = {
      kindLabels = {
        Text = "󰉿 text",
        Method = "󰆧 method",
        Function = "󰊕 function",
        Constructor = " constructor",
        Field = "󰜢 field",
        Variable = "󰀫 variable",
        Class = "󰠱 class",
        Interface = " interface",
        Module = " module",
        Property = "󰜢 property",
        Unit = "󰑭 unit",
        Value = "󰎠 value",
        Enum = " enum",
        Keyword = "󰌋 keyword",
        Snippet = " snippet",
        Color = "󰏘 color",
        File = "󰈙 file",
        Reference = "󰈇 reference",
        Folder = "󰉋 folder",
        EnumMember = " enum member",
        Constant = "󰏿 constant",
        Struct = "󰙅 struct",
        Event = " event",
        Operator = "󰆕 operator",
        TypeParameter = " type parameter",
      },
      kindHlGroups = {
        Method = "Function",
        Function = "Function",
        Constructor = "Function",
        Field = "Identifier",
        Variable = "Identifier",
        Class = "Structure",
        Interface = "Structure",
      },
    },
  },
  uiParams = {
    insert = true,
  },
  backspaceCompletion = true,
})

-- snippet keymaps
vim.keymap.set({ "i", "s" }, "<C-l>", function()
  luasnip.jump(1)
end)
vim.keymap.set({ "i", "s" }, "<C-h>", function()
  luasnip.jump(-1)
end)

vim.fn["ddc#enable_terminal_completion"]()
vim.fn["ddc#enable"]()

-- pum.vim config
vim.fn["pum#set_option"]({
  blend = 30,
  border = "rounded",
  item_orders = { "abbr", "space", "kind", "space", "menu" },
  offset_cmdrow = 2,
  scrollbar_char = "┃",
  use_setline = true,
  max_columns = {
    kind = 10,
    menu = 30,
  },
  -- preview = true,
  -- preview_border = "rounded",
  -- preview_delay = 100,
  -- preview_width = 30,
  -- preview_height = 30,
})

vim.fn["pum#set_local_option"]("c", {
  max_height = vim.go.lines - 20,
  preview = false,
})

-- language-specific configs
require("lsp-format").setup({})

---@param client vim.lsp.Client
---@param bufnr? number
local lspformat_on_attach = function(client, bufnr)
  require("lsp-format").on_attach(client, bufnr)
end

local lang_config = {
  elm = {
    lsp = {
      name = "elmls",
    },
    efm = {
      {
        formatCommand = "elm-format --stdin",
        formatStdin = true,
      },
    },
  },
  go = {
    lsp = {
      name = "gopls",
    },
    efm = {
      {
        formatCommand = "gofmt",
        formatStdin = true,
        lintCommand = "golangci-lint run",
        lintStdin = true,
      },
    },
  },
  haskell = {
    lsp = {
      name = "hls",
    },
    efm = {
      {
        formatCommand = "fourmolu --stdin-input-file",
        formatStdin = true,
      },
    },
  },
  html = {
    lsp = {
      name = "marksman",
    },
  },
  json = {
    lsp = {
      name = "jsonls",
    },
  },
  lua = {
    lsp = {
      name = "lua_ls",
      config = {
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
    },
    efm = {
      {
        formatCommand = "stylua --indent-type Spaces --indent-width 2 -",
        formatStdin = true,
      },
    },
    extraSources = { "nvim-lua" },
  },
  nim = {
    -- lsp = {
    --   name = "nim_langserver",
    --   config = {
    --     root_dir = lspconfig.util.root_pattern("*.nimble", ".git"),
    --     settings = {
    --       nim = {
    --         projectMapping = {
    --           projectFile = currentDir .. "src/" .. vim.fs.basename(currentDir) .. ".nim",
    --           fileRegex = ".*\\.nim",
    --         },
    --       },
    --     },
    --   },
    -- },
    efm = {
      {
        formatCommand = "nph -",
        formatStdin = true,
      },
    },
  },
  nix = {
    lsp = {
      name = "nil_ls",
      config = {
        settings = {
          flake = {
            autoArchive = true,
          },
        },
      },
    },
    efm = {
      {
        formatCommand = "nixfmt -",
        formatStdin = true,
      },
    },
  },
  scala = {
    lsp = {
      name = "metals",
    },
    efm = {
      {
        formatCommand = "scalafmt --stdin --non-interactive",
        formatCanRange = true,
        formatStdin = true,
      },
    },
  },
  svelte = {
    lsp = {
      name = "svelte",
      config = {
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
    },
  },
  toml = {
    lsp = {
      name = "taplo",
    },
    efm = {
      {
        formatCommand = "taplo format -",
        formatStdin = true,
      },
    },
  },
  typescript = {
    lsp = {
      name = "biome",
    },
    efm = {
      {
        formatCommand = "biome check --apply --stdin-file-path '${INPUT}'",
        formatStdin = true,
        rootMarkers = { "rome.json", "biome.json", "package.json" },
      },
    },
  },
  typst = {
    lsp = {
      name = "typst_lsp",
    },
  },
  zig = {
    lsp = {
      name = "zls",
      config = {
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
    },
    efm = {
      {
        formatCommand = "zig fmt --stdin",
        formatStdin = true,
      },
    },
  },
}

require("ddc_source_lsp_setup").setup({
  override_capabilities = true,
  respect_trigger = true,
})

local lspconfig = require("lspconfig")
local efm_filetypes = {}
local efm_languages = {}

---@param lsp { name: string, config?: table, format?: boolean }
local load_language_config = function(lsp)
  if next(lsp) == nil then
    return
  end
  lspconfig[lsp.name].setup(lsp.config or {})
end

for ft, config in pairs(lang_config) do
  vim.fn["ddc#custom#patch_filetype"]({ ft }, {
    sources = utils.array_concat_unique(commonLangSources, config.extraSources or {}),
  })
  load_language_config(config.lsp or {})
  table.insert(efm_filetypes, ft)
  efm_languages[ft] = config.efm or {}
end

lspconfig.efm.setup({
  on_attach = lspformat_on_attach,
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
  },
  single_file_support = true,
  filetypes = efm_filetypes,
  settings = {
    rootMarkers = {
      ".git/",
    },
    languages = efm_languages,
  },
})

lspconfig.denols.setup({
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
  root_dir = lspconfig.util.root_pattern("deno.json", "dpp.ts"),
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

-- completion keymaps
local pum_forward = function()
  vim.fn["pum#map#insert_relative"](1, "loop")
end
local pum_backward = function()
  vim.fn["pum#map#insert_relative"](-1, "loop")
end
local pum_forward_term = function()
  vim.fn["pum#map#select_relative"](1, "loop")
end
local pum_backward_term = function()
  vim.fn["pum#map#select_relative"](-1, "loop")
end
local pum_confirm = function()
  vim.fn["pum#map#confirm"]()
end

vim.keymap.set({ "i" }, "<C-n>", pum_forward)
vim.keymap.set({ "i" }, "<C-p>", pum_backward)

vim.keymap.set({ "t" }, "<C-n>", pum_forward_term)
vim.keymap.set({ "t" }, "<C-p>", pum_backward_term)

vim.keymap.set({ "i", "t" }, "<C-y>", pum_confirm)

vim.keymap.set("n", ":", "<Cmd>CommandlinePre<CR>:")
-- vim.keymap.set("n", "/", "<Cmd>CommandlinePre<CR>/")

vim.api.nvim_create_user_command("CommandlinePre", function()
  vim.keymap.set("c", "<C-n>", pum_forward)
  vim.keymap.set("c", "<C-p>", pum_backward)
  vim.keymap.set("c", "<C-y>", pum_confirm)

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "DDCCmdlineLeave",
    once = true,
    callback = function()
      utils.unmap("c", "<C-n>", { silent = true })
      utils.unmap("c", "<C-p>", { silent = true })
      utils.unmap("c", "<C-y>", { silent = true })
    end,
  })
  vim.fn["ddc#enable_cmdline_completion"]()
end, {})
--- }}}
