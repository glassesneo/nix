--- lua_source {{{
vim.fn["ddc#custom#patch_filetype"]({ "lua" }, {
  sources = {
    "nvim-lua",
    "lsp",
    -- "codeium",
    "skkeleton",
    "around",
    -- "treesitter",
    "file",
    "buffer",
  },
})

vim.fn["ddc#custom#patch_filetype"]({ "nim" }, {
  sources = {
    "lsp",
    -- "codeium",
    "skkeleton",
    "around",
    -- "treesitter",
    "file",
    "buffer",
  },
})

vim.fn["ddc#custom#patch_filetype"]({ "markdown" }, {
  sources = {
    -- "obsidian_tag",
    -- "obsidian_link",
    -- "codeium",
    "skkeleton",
    "around",
    -- "treesitter",
    "file",
    "buffer",
  },
  -- sourceParams = {
  --   obsidian_tag = {
  --     vault = vim.fn.getcwd(),
  --   },
  --   obsidian_link = {
  --     vault = vim.fn.getcwd(),
  --   },
  -- },
})

vim.fn["ddc#custom#patch_global"]({
  ui = "pum",
  sources = {
    "lsp",
    -- "codeium",
    "skkeleton",
    "around",
    -- "treesitter",
    "file",
    "buffer",
  },
  cmdlineSources = {
    [":"] = {
      "cmdline",
      "cmdline-history",
      "path",
      "around",
    },
  },
  autoCompleteEvents = {
    "InsertEnter",
    "TextChangedI",
    "TextChangedP",
    "TextChangedT",
    "CmdlineEnter",
    "CmdlineChanged",
  },
  sourceOptions = {
    ["_"] = {
      matchers = {
        "matcher_fuzzy",
      },
      sorters = {
        "sorter_fuzzy",
      },
      converters = {
        "converter_fuzzy",
        "converter_kind_labels",
        "converter_remove_overlap",
        "converter_truncate_abbr",
      },
      minAutoCompleteLength = 1,
      ignoreCase = true,
    },
    lsp = {
      mark = "[LSP]",
      dup = "keep",
      keywordPattern = "\\k+",
      sorters = {
        "sorter_fuzzy",
        "sorter_lsp-kind",
      },
      converters = {
        "converter_kind_labels",
        "converter_remove_overlap",
      },
      minAutoCompleteLength = 0,
    },
    -- codeium = {
    --   mark = "[Codeium]",
    --   matchers = {},
    --   sorters = {},
    --   converters = {},
    --   minAutoCompleteLength = 0,
    --   timeout = 1000,
    --   isVolatile = true,
    --   enabledIf = "!skkeleton#is_enabled()",
    -- },
    skkeleton = {
      mark = "[SKK]",
      matchers = {},
      sorters = {},
      converters = {},
      isVolatile = true,
      minAutoCompleteLength = 1,
    },
    around = {
      mark = "[around]",
    },
    -- treesitter = {
    --   mark = "[TS]",
    -- },
    buffer = {
      mark = "[buf]",
    },
    file = {
      mark = "[file]",
      forceCompletionPattern = [[\S/\S*]],
      isVolatile = true,
    },
    path = {
      mark = "[path]",
      forceCompletionPattern = [[\S/\S*]],
      isVolatile = true,
    },
    cmdline = {
      mark = "[>_]",
      forceCompletionPattern = [[\S/\S*|\.\w*]],
    },
    ["cmdline-history"] = {
      mark = "[>_ his]",
      sorters = {},
    },
    -- ["shell-history"] = {
    -- mark = "[shell]",
    -- matchers = { "matcher_head" },
    -- sorters = { "sorter_rank" },
    -- },
    -- ["shell-native"] = {
    --   mark = "[fish]",
    --   matchers = { "matcher_head" },
    --   isVolatile = true,
    --   minAutoCompleteLength = 0,
    --   forceCompletionPattern = [[\S/\S*]],
    -- },
    ["nvim-lua"] = {
      mark = "[lua]",
      forceCompletionPattern = [[\.\w*]],
    },
  },
  sourceParams = {
    -- lsp = {
    --   snippetEngine = vim.fn["denops#callback#register"](function(body)
    --     require("luasnip").lsp_expand(body)
    --   end),
    --   confirmBehavior = "insert",
    -- },
    buffer = {
      limitBytes = 5000000,
      forceCollect = true,
    },
    -- ["shell-native"] = {
    --   shell = "fish",
    -- },
    deol = {
      command = "fish",
    },
  },
  postFilters = {
    "postfilter_score",
  },
  filterParams = {
    converter_fuzzy = {
      hlGroup = "Title",
    },
    postfilter_score = {
      excludeSources = { "skkeleton" },
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
      kinHlGroups = {
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

vim.fn["ddc#custom#patch_filetype"]({ "deol" }, {
  specialBufferCompletion = true,
  sources = {
    "cmdline",
    "cmdline-history",
    -- "shell-native",
    -- "shell-history",
    "path",
    "file",
  },
  cmdlineSources = {
    [":"] = {
      "cmdline",
      "cmdline-history",
      "path",
      "around",
    },
  },
})

vim.fn["ddc#enable_terminal_completion"]()

vim.fn["ddc#enable"]()

-- ddu
-- vim.fn["ddc#custom#patch_filetype"]({ "ddu-ff" }, {
--   sources = {},
-- })

local utils = require("utils")
local map = utils.map
local unmap = utils.unmap

local pum_forward = function()
  vim.fn["pum#map#insert_relative"](1, "loop")
end
local pum_backward = function()
  vim.fn["pum#map#insert_relative"](-1, "loop")
end
local pum_confirm = function()
  vim.fn["pum#map#confirm"]()
end

local pum_forward_term = function()
  vim.fn["pum#map#select_relative"](1, "loop")
end
local pum_backward_term = function()
  vim.fn["pum#map#select_relative"](-1, "loop")
end

vim.fn["pum#set_option"]({
  border = "rounded",
  item_orders = { "kind", "space", "abbr", "space", "menu" },
  scrollbar_char = "┃",
})

vim.fn["pum#set_local_option"]("c", {
  border = "none",
})

map({ "i" }, "<C-n>", pum_forward)
map({ "i" }, "<C-p>", pum_backward)

map({ "t" }, "<C-n>", pum_forward_term)
map({ "t" }, "<C-p>", pum_backward_term)

map({ "i", "t" }, "<C-y>", pum_confirm)

map("n", ":", "<Cmd>CommandlinePre<CR>:")

vim.api.nvim_create_user_command("CommandlinePre", function()
  map("c", "<C-n>", pum_forward)
  map("c", "<C-p>", pum_backward)
  map("c", "<C-y>", pum_confirm)

  vim.api.nvim_create_autocmd({ "User" }, {
    pattern = "DDCCmdlineLeave",
    once = true,
    callback = function()
      unmap("c", "<C-n>", { silent = true })
      unmap("c", "<C-p>", { silent = true })
      unmap("c", "<C-y>", { silent = true })
    end,
  })
  vim.fn["ddc#enable_cmdline_completion"]()
end, {})
--- }}}
