--- lua_add {{{
local utils = require("utils")

local doAction = vim.fn["ddu#ui#do_action"]
local multiActions = vim.fn["ddu#ui#multi_actions"]
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

---@param mode string|string[]
---@param key string
---@param actionTable ([string]|[string, table])[]
local function mapMultiActions(mode, key, actionTable)
  utils.map(mode, key, function()
    multiActions(actionTable)
  end, { noremap = true, silent = true, buffer = true })
end

-- ui-filer
local windowSize = {
  x = (vim.go.columns - vim.go.columns % 2) / 2 - 20,
  y = 20,
}
local windowPosition = {
  x = (vim.go.columns - windowSize.x) / 2 + 20,
  y = (vim.go.lines - vim.go.lines % 2) / 2 - 10,
}

local previewSize = {
  x = (vim.go.columns - vim.go.columns % 2) / 2 - 20,
  y = 20,
}
local previewPosition = {
  x = windowPosition.x - previewSize.x,
  y = windowSize.y,
}

vim.fn["ddu#custom#patch_local"]("floating_filer", {
  actionOptions = {
    open = {
      rename = false,
    },
  },
  ui = "filer",
  uiParams = {
    displayRoot = true,
    filer = {
      sortTreesFirst = true,
      split = "floating",
      statusline = false,
      floatingBorder = "rounded",
      previewFloating = true,
      previewFloatingBorder = "rounded",
      previewFloatingTitle = "Preview",
      previewSplit = "horizontal",
      winWidth = windowSize.x,
      winHeight = windowSize.y,
      winCol = windowPosition.x,
      winRow = windowPosition.y,
      previewWidth = previewSize.x,
      prebiewHeight = previewSize.y,
      previewCol = previewPosition.x - 2,
      previewRow = previewPosition.y + 2,
    },
  },
  sources = { "file" },
  sourceOptions = {
    ["_"] = {
      sorters = {
        "sorter_alpha",
      },
      converters = {},
    },
    file = {
      columns = {
        "icon_filename",
      },
    },
  },
})

customAction("ui", "filer", "select", function()
  local item = vim.fn["ddu#ui#get_item"]()
  if item.isTree then
    doAction("itemAction", { name = "narrow" })
  else
    doAction("itemAction", { name = "open" })
  end
end)

customAction("ui", "filer", "vsOpen", function()
  local item = vim.fn["ddu#ui#get_item"]()
  if item.isTree then
    vim.notify("The item is not a file.", vim.log.levels.ERROR)
  else
    doAction("itemAction", { name = "open", params = { command = "vsplit" } })
  end
end)

customAction("ui", "filer", "updatePreview", function()
  local item = vim.fn["ddu#ui#get_item"]()
  if item.isTree then
    doAction("closePreviewWindow")
  else
    doAction("preview")
  end
end)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "ddu-filer",
  callback = function()
    mapAction("n", "q", "quit")
    mapAction("n", "<CR>", "select")
    mapAction("n", "<BS>", "itemAction", { name = "narrow", params = { path = ".." } })
    mapMultiActions("n", "j", { { "cursorNext" }, { "updatePreview" } })
    mapMultiActions("n", "k", { { "cursorPrevious" }, { "updatePreview" } })
    mapAction("n", "l", "expandItem")
    mapAction("n", "h", "collapseItem")
    mapAction("n", "r", "itemAction", { name = "rename" })
    mapAction("n", "u", "itemAction", { name = "undo" })
    doAction("updatePreview")
  end,
})

utils.map("n", "<Space><Space>", function()
  vim.fn["ddu#start"]({ name = "floating_filer" })
end)
--- }}}
