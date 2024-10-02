--- lua_source {{{
local utils = require("utils")
local luasnip = require("luasnip")

local commonSources = {
  "around",
  "rg",
  "file",
}

local commonLangSources = utils.array_concat_unique({
  "lsp",
  "treesitter",
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
      "path",
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
      minAutoCompleteLength = 1,
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
    },
    ["cmdline-history"] = {
      mark = "[>_ his]",
      sorters = {},
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
    path = {
      mark = "[path]",
      forceCompletionPattern = [[\S/\S*]],
      isVolatile = true,
    },
    rg = {
      mark = "[rg]",
      matchers = {
        "matcher_fuzzy",
      },
      sorters = {
        "sorter_fuzzy",
      },
      converters = fuzzyConverters,
      minAutoCompleteLength = 2,
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
      -- minAutoCompleteLength = 6,
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
      snippetEngine = vim.fn["denops#callback#register"](function(body)
        luasnip.lsp_expand(body)
      end),
    },
    path = {
      cmd = { "fd", "--max-depth", "5" },
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

local filetypes = {
  ["go"] = {},
  ["html"] = {},
  ["lua"] = { "nvim-lua" },
  ["nim"] = {},
  ["python"] = {},
  ["rust"] = {},
  ["tsx"] = {},
  ["typescript"] = {},
  ["typescriptreact"] = {},
}

for ft, extra in pairs(filetypes) do
  if #extra == 0 then
    vim.fn["ddc#custom#patch_filetype"]({ ft }, {
      sources = commonLangSources,
    })
  else
    local ftSources = utils.array_concat_unique(commonLangSources, extra)
    vim.fn["ddc#custom#patch_filetype"]({ ft }, {
      sources = ftSources,
    })
  end
end

-- snippet keymaps
utils.map({ "i", "s" }, "<C-l>", function()
  luasnip.jump(1)
end)
utils.map({ "i", "s" }, "<C-h>", function()
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

utils.map({ "i" }, "<C-n>", pum_forward)
utils.map({ "i" }, "<C-p>", pum_backward)

utils.map({ "t" }, "<C-n>", pum_forward_term)
utils.map({ "t" }, "<C-p>", pum_backward_term)

utils.map({ "i", "t" }, "<C-y>", pum_confirm)

utils.map("n", ":", "<Cmd>CommandlinePre<CR>:")
utils.map("n", "/", "<Cmd>CommandlinePre<CR>/")

vim.api.nvim_create_user_command("CommandlinePre", function()
  utils.map("c", "<C-n>", pum_forward)
  utils.map("c", "<C-p>", pum_backward)
  utils.map("c", "<C-y>", pum_confirm)

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
