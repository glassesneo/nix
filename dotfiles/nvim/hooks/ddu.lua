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

-- ui-ff
vim.fn["ddu#custom#patch_local"]("floating_finder", {
  ui = "ff",
  uiParams = {
    ff = {
      startAutoAction = true,
      autoAction = {
        delay = 0,
        name = "preview",
      },
      split = "floating",
      statusline = false,
      floatingBorder = "rounded",
      prompt = "Search: ",
      previewFloating = true,
      previewFloatingBorder = "rounded",
      previewFloatingTitle = "Preview",
      previewWidth = (vim.go.columns - vim.go.columns % 2) / 2,
      -- inputFunc = function(prompt, default)
      --   default = default or ""
      --   local result = nil
      --   vim.ui.input({ prompt = prompt, default = default }, function(input)
      --     result = input or default
      --   end)
      --   return result
      -- end,
    },
  },
  sources = {
    "file_rec",
    -- "file_old",
  },
  sourceOptions = {
    ["_"] = {
      matchers = {
        "matcher_substring",
      },
      sorters = {
        "sorter_alpha",
      },
      converters = {},
      columns = {
        "icon_filename",
      },
    },
  },
  kindOptions = {
    ui_select = {
      defaultAction = "select",
    },
  },
})

customAction("ui", "ff", "select", function()
  local item = vim.fn["ddu#ui#get_item"]()
  if item.isTree then
    doAction("itemAction", { name = "narrow" })
  else
    doAction("itemAction", { name = "open" })
  end
end)

customAction("ui", "ff", "vsOpen", function()
  local item = vim.fn["ddu#ui#get_item"]()
  if item.isTree then
    vim.notify("The item is not a file.", vim.log.levels.ERROR)
  else
    doAction("itemAction", { name = "open", params = { command = "vsplit" } })
  end
end)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "ddu-ff",
  callback = function()
    mapAction("n", "q", "quit")
    mapAction("n", "<CR>", "itemAction", { name = "open" })
    mapAction("n", "u", "itemAction", { name = "undo" })
    mapAction("n", "p", "togglePreview")
    mapAction("n", "/", "openFilterWindow")
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "Ddu:ui:ff:openFilterWindow",
  callback = function()
    vim.fn["ddu#ui#ff#save_cmaps"]({ "<C-n>", "<C-p>", "<CR>" })
    mapAction("c", "<C-n>", "cursorNext", { loop = true })
    mapAction("c", "<C-p>", "cursorPrevious", { loop = true })
    -- utils.map("c", "<CR>", function()
    --   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-c>", true, true, true), "n", false)
    -- end)
    utils.map("c", "<CR>", "<Cmd>OpenFileCmd<CR><Esc>")
  end,
})

vim.api.nvim_create_user_command("OpenFileCmd", function()
  doAction("itemAction", { name = "open" })
end, {})

vim.api.nvim_create_autocmd("User", {
  pattern = "Ddu:ui:ff:closeFilterWindow",
  callback = function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-c>", true, true, true), "n", false)
    vim.fn["ddu#ui#ff#restore_cmaps"]()
  end,
})

utils.map("n", "<Space><Space>", function()
  vim.fn["ddu#start"]({ name = "floating_finder" })
end)

-- ddu-filer
vim.fn["ddu#custom#patch_local"]("side_filer", {
  ui = "filer",
  uiParams = {
    filer = {
      displayRoot = false,
      sortTreesFirst = true,
      split = "vertical",
      splitDirection = "topleft",
      statusline = false,
      winWidth = 25,
      previewFloating = true,
      previewSplit = "vertical",
      previewFloatingBorder = "rounded",
      previewFloatingTitle = "Preview",
      previewCol = 2,
      previewWidth = vim.go.columns - (25 + 10),
      previewHeight = 30,
    },
  },
  sources = { "file" },
  sourceOptions = {
    ["_"] = {
      matchers = {},
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
  kindOptions = {
    file = {
      defaultAction = "open",
    },
  },
  actionOptions = {
    open = {
      quit = false,
    },
  },
})

customAction("ui", "filer", "filerOpen", function()
  local item = vim.fn["ddu#ui#get_item"]()
  if item.isTree then
    doAction("expandItem", { mode = "toggle", isInTree = true })
  else
    doAction("itemAction", { name = "open" })
    -- doAction("itemAction", { name = "open", params = { command = "wincmd p <Bar> drop" } })
    -- vim.cmd([[call ddu#ui#do_action('itemAction', {'name': 'open', 'params': {'command': 'wincmd p <Bar> drop'}})]])
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

local toggleGitStatus = function()
  local current = vim.fn["ddu#custom#get_current"](vim.b.ddu_ui_name)
  local converters = current["sourceOptions"]["file"]["converters"]
  if #converters == 0 then
    return { "converter_git_status" }
  else
    return {}
  end
end

customAction("ui", "filer", "toggleGitStatus", function()
  doAction("updateOptions", {
    sourceOptions = {
      file = {
        converters = toggleGitStatus(),
      },
    },
  })
  doAction("redraw")
end)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "ddu-filer",
  callback = function()
    mapAction("n", "q", "quit")
    mapAction("n", "<CR>", "filerOpen")
    -- mapAction("n", "<BS>", "itemAction", { name = "narrow", params = { path = ".." } })
    mapMultiActions("n", "j", {
      { "cursorNext" },
      { "updatePreview" },
    })
    mapMultiActions("n", "k", {
      { "cursorPrevious" },
      { "updatePreview" },
    })
    mapMultiActions("n", "l", {
      { "expandItem", { isInTree = true } },
      { "updatePreview" },
    })
    mapMultiActions("n", "<S-l>", {
      { "expandItem", { maxLevel = -1, isInTree = true } },
      { "updatePreview" },
    })
    mapAction("n", "h", "collapseItem")
    mapMultiActions("n", "r", {
      { "itemAction", { name = "rename" } },
      { "updatePreview" },
    })
    -- mapAction("n", "g", "toggleGitStatus")
    mapAction("n", "u", "itemAction", { name = "undo" })
    doAction("updatePreview")
  end,
})

utils.map("n", "<Space>f", function()
  vim.fn["ddu#start"]({ name = "side_filer" })
end)
--- }}}
