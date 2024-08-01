--- lua_add {{{
local utils = require("utils")

local doAction = vim.fn["ddu#ui#async_action"]

local customAction = vim.fn["ddu#custom#action"]

---@param mode string|string[]
---@param key string
---@param action string
---@param args? table
local function mapAction(mode, key, action, args)
  utils.map(mode, key, function()
    if args ~= nil and next(args) then
      doAction(action, args)
    else
      doAction(action)
    end
  end, { noremap = true, silent = true, buffer = true })
end

-- vim.fn["ddu#custom#patch_global"]({
--   ui = "ff",
--   uiParams = {
--     ff = {
--       filterFloatingPosition = "bottom",
--       filterSplitDirection = "floating",
--       floatingBorder = "rounded",
--       previewFloating = true,
--       previewFloatingBorder = "rounded",
--       previewFloatingTitle = "Preview",
--       previewSplit = "horizontal",
--       prompt = "> ",
--       split = "floating",
--       startFilter = true,
--     },
--     filer = {
--       splitDirection = "floating",
--       floatingBorder = "rounded",
--       previewFloating = true,
--       previewFloatingBorder = "rounded",
--       previewFloatingTitle = "Preview",
--       previewSplit = "horizontal",
--     },
--   },
--   sourceOptions = {
--     ["_"] = {
--       matchers = {
--         "matcher_substring",
--       },
--       ignoreCase = true,
--     },
--     file = {
--       converters = {
--         "converter_devicon",
--       },
--       columns = {
--         "filename",
--       },
--     },
--   },
--   kindOptions = {},
-- })

-- ui-ff

customAction("ui", "ff", "git_select", function()
  local source_action_map = {
    ["git_status"] = function()
      doAction("execute")
    end,
  }
  local item = vim.fn["ddu#ui#get_item"]()
  local source_name = item.display
  source_action_map[source_name]()
end)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "ddu-ff",
  callback = function()
    mapAction("n", "q", "quit")
    -- mapAction("n", "<CR>", "git_select")
  end,
})

-- git

vim.fn["ddu#custom#patch_local"]("git", {
  ui = "ff",
  uiParams = {
    ff = {
      split = "floating",
      splitDirection = "floating",
      floatingBorder = "rounded",
      previewFloating = true,
      previewFloatingBorder = "rounded",
      previewFloatingTitle = "Preview",
      previewSplit = "horizontal",
    },
  },
  sources = {
    {
      name = "git_status",
      options = {
        matchers = {
          -- matcher_specific_items = {
          --   startsWith = "git",
          -- },
        },
      },
    },
  },
})

utils.map("n", "<Space>G", function()
  vim.fn["ddu#start"]({
    name = "git",
    sourceOptions = {},
    uiParams = {
      ff = {
        split = "floating",
      },
    },
  })
end)

-- ui-filer

customAction("ui", "filer", "select", function()
  local item = vim.fn["ddu#ui#get_item"]()
  if item.isTree then
    doAction("itemAction", { name = "narrow" })
  else
    doAction("itemAction", { name = "open" })
  end
end)

customAction("ui", "filer", "open_cwd", function()
  local cwd = vim.fn.getcwd()
  doAction("itemAction", { name = "narrow", params = { path = cwd } })
end)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "ddu-filer",
  callback = function()
    mapAction("n", "q", "quit")
    mapAction("n", "<CR>", "select")
    mapAction("n", "<BS>", "itemAction", { name = "narrow", params = { path = ".." } })
    mapAction("n", "l", "expandItem")
    mapAction("n", "h", "collapseItem")
    mapAction("n", "o", "itemAction", { name = "newFile" })
    mapAction("n", "r", "itemAction", { name = "rename" })
    mapAction("n", "u", "itemAction", { name = "undo" })
    mapAction("n", "dd", "itemAction", { name = "delete" })
    mapAction("n", "yy", "itemAction", { name = "yank" })
    mapAction("n", "_", "open_cwd")
  end,
})

-- filer
vim.fn["ddu#custom#patch_local"]("filer", {
  ui = "filer",
  uiParams = {
    filer = {
      splitDirection = "floating",
      floatingBorder = "rounded",
      previewFloating = true,
      previewFloatingBorder = "rounded",
      previewFloatingTitle = "Preview",
      previewSplit = "horizontal",
    },
  },
  sources = { "file" },
  sourceOptions = {
    file = {
      sorters = {
        "sorter_alpha",
      },
      converters = {
        "converter_devicon",
      },
      columns = {
        "filename",
      },
    },
  },
})

utils.map("n", "<Space><Space>", function()
  vim.fn["ddu#start"]({
    name = "filer",
    sourceOptions = {},
    uiParams = {
      filer = {
        split = "floating",
      },
    },
  })
end)

utils.map("n", "-", function()
  vim.fn["ddu#start"]({
    name = "filer",
    sourceOptions = {},
    uiParams = {
      filer = {
        split = "no",
      },
    },
  })
end)
--- }}}
