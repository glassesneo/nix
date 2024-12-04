--- lua_add {{{
local doAction = vim.fn["ddu#ui#do_action"]
local multiActions = vim.fn["ddu#ui#multi_actions"]
local customAction = vim.fn["ddu#custom#action"]

---@param mode string|string[]
---@param key string
---@param action string
---@param args? table
local function mapAction(mode, key, action, args)
  vim.keymap.set(mode, key, function()
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
  vim.keymap.set(mode, key, function()
    multiActions(actionTable)
  end, { noremap = true, silent = true, buffer = true })
end

-- wip
local previewExcludeFileTypes = {
  "mp3",
  "mp4",
  "wav",
  "png",
  "jpeg",
  "jpg",
  "bmp",
}

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
      winRow = (vim.go.lines - vim.go.lines % 2) / 2 - 9,
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
        "matcher_ignore_files",
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
  sourceParams = {
    file_rec = {
      ignoredDirectories = {
        ".git",
        "nimcache",
        "testresults",
      },
    },
  },
  filterParams = {
    matcher_ignore_files = {
      ignoreGlobs = { "testresults.html", ".DS_Store" },
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
    vim.opt.cursorline = true
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
    vim.keymap.set("c", "<CR>", "<Cmd>OpenFileCmd<CR><Esc>")
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

vim.keymap.set("n", "<Space><Space>", function()
  vim.fn["ddu#start"]({ name = "floating_finder" })
end)

-- ddu-filer
vim.fn["ddu#custom#patch_local"]("side_filer", {
  ui = "filer",
  uiParams = {
    filer = {
      startAutoAction = true,
      autoAction = {
        delay = 0,
        name = "updatePreview",
      },
      displayRoot = false,
      sortTreesFirst = true,
      split = "vertical",
      splitDirection = "topleft",
      statusline = false,
      winWidth = 25,
      -- previewFloating = true,
      previewSplit = "no",
      -- previewFloatingBorder = "rounded",
      -- previewFloatingTitle = "Preview",
      -- previewCol = 2,
      -- previewWidth = vim.go.columns - (25 + 10),
      -- previewHeight = 30,
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
  filterParams = {
    matcher_ignore_files = {
      ignoreGlobs = { ".DS_Store" },
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
    doAction("closePreviewWindow")
    doAction("itemAction", { name = "open", params = { command = "wincmd l | drop" } })
  end
end)

customAction("ui", "filer", "filerOpenAndLeave", function()
  local item = vim.fn["ddu#ui#get_item"]()
  if item.isTree then
    return
  else
    doAction("closePreviewWindow")
    doAction("itemAction", { name = "open" })
  end
end)

customAction("ui", "filer", "updatePreview", function()
  local item = vim.fn["ddu#ui#get_item"]()
  local extension = vim.fn.fnamemodify(item.word, ":e")
  if item.isTree or extension == "" then
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
    vim.opt.cursorline = true
    mapAction("n", "q", "quit")
    mapAction("n", "<CR>", "filerOpen")
    mapAction("n", "<S-l>", "filerOpenAndLeave")
    mapAction("n", "l", "expandItem", { isInTree = true })
    mapAction("n", "<S-l>", "expandItem", { maxLevel = -1, isInTree = true })
    mapAction("n", "h", "collapseItem")
    mapAction("n", "p", "togglePreview")
    mapAction("n", "r", "itemAction", { name = "rename" })
    mapAction("n", "u", "itemAction", { name = "undo" })
    -- mapAction("n", "g", "toggleGitStatus")
  end,
})

vim.keymap.set("n", "<Space>f", function()
  local windows = vim.api.nvim_list_wins()
  for _, win in ipairs(windows) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buf_filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
    if buf_filetype == "ddu-filer" then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
  vim.fn["ddu#start"]({ name = "side_filer" })
end)
--- }}}
