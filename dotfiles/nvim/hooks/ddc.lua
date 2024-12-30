--- lua_source {{{
local utils = require("utils")
local luasnip = require("luasnip")
local artemis = require("artemis")

artemis.fn.ddc.custom.load_config(vim.env.HOOK_DIR .. "/ddc.ts")

local commonLangSources = {
  "lsp",
  "around",
  "rg",
  "file",
  -- "skkeleton",
}

-- snippet keymaps
vim.keymap.set({ "i", "s" }, "<C-l>", function()
  luasnip.jump(1)
end)
vim.keymap.set({ "i", "s" }, "<C-h>", function()
  luasnip.jump(-1)
end)

artemis.fn.ddc.enable_terminal_completion()
artemis.fn.ddc.enable()

-- pum.vim config
artemis.fn.pum.set_option({
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
  -- insert_preview = true,
  preview = true,
  preview_border = "rounded",
  preview_delay = 100,
  preview_width = 30,
  preview_height = 30,
})

artemis.fn.pum.set_local_option("c", {
  -- follow_cursor = true,
  -- max_height = vim.go.lines - 20,
  -- preview = false,
})

-- language-specific configs
require("lsp-format").setup({})

---@param client vim.lsp.Client
---@param bufnr? number
local lspformat_on_attach = function(client, bufnr)
  require("lsp-format").on_attach(client, bufnr)
end

require("ddc_source_lsp_setup").setup({
  override_capabilities = true,
  respect_trigger = true,
})

local lspconfig = require("lspconfig")
local efm_filetypes = {}
local efm_languages = {}

local filetype_config = {
  elm = {
    efm = {
      {
        formatCommand = "elm-format --stdin",
        formatStdin = true,
      },
    },
  },
  -- go = {
  --   efm = {
  --     {
  --       formatCommand = "gofmt",
  --       formatStdin = true,
  --       lintCommand = "golangci-lint run",
  --       lintStdin = true,
  --     },
  --   },
  -- },
  -- haskell = {
  --   efm = {
  --     {
  --       formatCommand = "stack exec fourmolu --stdin-input-file",
  --       formatStdin = true,
  --     },
  --   },
  -- },
  lua = {
    extraSources = { "nvim-lua" },
    efm = {
      {
        formatCommand = "stylua --indent-type Spaces --indent-width 2 -",
        formatStdin = true,
      },
    },
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
    efm = {
      {
        formatCommand = "nixfmt -",
        formatStdin = true,
      },
    },
  },
  python = {
    efm = {
      {
        formatCommand = "ruff format -",
        formatStdin = true,
      },
    },
  },
  scala = {
    efm = {
      {
        formatCommand = "scalafmt --stdin --non-interactive",
        formatCanRange = true,
        formatStdin = true,
      },
    },
  },
  sql = {
    filetypes = { "sql", "mysql" },
    efm = {
      {
        formatCommand = "sql-formatter",
        formatCanRange = true,
        formatStdin = true,
      },
    },
  },
  svelte = {},
  toml = {
    efm = {
      {
        formatCommand = "taplo format -",
        formatStdin = true,
      },
    },
  },
  typescript = {
    filetypes = { "typescript", "typescriptreact", "javascript" },
    efm = {
      {
        formatCommand = "biome check --apply --stdin-file-path '${INPUT}'",
        formatStdin = true,
        rootMarkers = { "biome.json", "package.json" },
      },
    },
  },
  kotlin = {
    filetypes = { "kotlin", "kotlin.kts" },
    efm = {
      {
        formatCommand = "ktfmt -",
        formatStdin = true,
      },
    },
  },
  v = {
    filetypes = { "v", "vsh", "vv" },
    efm = {
      {
        formatCommand = "v fmt",
        formatStdin = true,
      },
    },
  },
  zig = {
    filetypes = { "zig", "zir" },
    efm = {
      {
        formatCommand = "zig fmt --stdin",
        formatStdin = true,
      },
    },
  },
}

---@param ft string
---@param config { efm: table, extraSources: string[] }
local register_language = function(ft, config)
  artemis.fn.ddc.custom.patch_filetype({ ft }, {
    sources = utils.array_concat_unique(commonLangSources, config.extraSources or {}),
  })
  table.insert(efm_filetypes, ft)
  efm_languages[ft] = config.efm or {}
end

for ft, config in pairs(filetype_config) do
  if config.filetypes ~= nil then
    for _, ft2 in ipairs(config.filetypes) do
      register_language(ft2, config)
    end
  else
    register_language(ft, config)
  end
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

-- completion keymaps
local pum_forward = function()
  artemis.fn.pum.map.insert_relative(1, "loop")
end
local pum_backward = function()
  artemis.fn.pum.map.insert_relative(-1, "loop")
end
local pum_forward_term = function()
  artemis.fn.pum.map.select_relative(1, "loop")
end
local pum_backward_term = function()
  artemis.fn.pum.map.select_relative(-1, "loop")
end
local pum_confirm = function()
  artemis.fn.pum.map.confirm()
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
  artemis.fn.ddc.enable_cmdline_completion()
end, {})
--- }}}
