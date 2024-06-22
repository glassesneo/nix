--- lua_source {{{
local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

local everforest = require("lualine.themes.everforest")

require("lualine").setup({
  options = {
    section_separators = { left = "", right = "" },
    component_separators = { left = "", right = "" },
    globalstatus = true,
    theme = everforest,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
      {
        "filename",
        newfile_status = true,
        path = 3,
        shorting_target = 30,
        symbols = {
          modified = "_",
          readonly = " ",
          newfile = "󰘩 ",
        },
      },
      {
        "searchcount",
        draw_empty = true,
      },
    },
    lualine_c = {
      {
        "location",
      },
    },
    lualine_x = { "encoding" },
    lualine_y = {
      {
        "filetype",
      },
      {
        "fileformat",
        icons_enabled = true,
        symbols = {
          unix = "",
          mac = "",
        },
      },
    },
    lualine_z = {},
  },
  -- tabline = {
  --   lualine_a = {
  --     {
  --       "buffers",
  --       mode = 4,
  --       symbols = {
  --         modified = "_",
  --         alternate_file = " ",
  --         directory = " ",
  --       },
  --       filetype_names = {
  --         oil = "Oil",
  --         alpha = "Alpha",
  --       },
  --     },
  --   },
  --   lualine_b = {},
  --   lualine_c = {},
  --   lualine_x = {},
  --   lualine_y = {
  --     {
  --       "tabs",
  --       mode = 2,
  --       path = 1,
  --     },
  --   },
  --   lualine_z = {
  --     {
  --       "datetime",
  --       style = "%m/%d(%A) %H:%M",
  --     },
  --   },
  -- },
  winbar = {
    lualine_a = {
      {
        "diagnostics",
        sources = { "nvim_diagnostic", "nvim_lsp" },
        sections = { "error", "warn", "info", "hint" },
        symbols = {
          error = " ",
          warn = " ",
          info = " ",
          hint = " ",
        },
        separator = { left = "", right = "" },
        color = { bg = "#fad600" },
      },
    },
    lualine_b = {
      {
        "navic",
        separator = { left = "", right = "" },
        draw_empty = true,
      },
    },
    lualine_c = {},
    lualine_x = {
      {
        "diff",
        symbols = {
          added = " ",
          modified = " ",
          removed = " ",
        },
        source = diff_source,
      },
    },
    lualine_y = {
      {
        "b:gitsigns_head",
        icon = { "", color = { fg = "#ffba4f" } },
      },
    },
    lualine_z = {
      {
        "location",
        -- separator = {left = '', right = ''},
        draw_empty = true,
        color = { bg = "#fad600" },
      },
      {
        "filesize",
        -- separator = { left = '║', right = '║' },
        color = { bg = "#fad600" },
      },
    },
  },
  inactive_winbar = {
    lualine_a = {
      {
        "diagnostics",
        sources = { "nvim_diagnostic", "nvim_lsp" },
        sections = { "error", "warn", "info", "hint" },
        symbols = {
          error = " ",
          warn = " ",
          info = " ",
          hint = " ",
        },
        separator = { left = "", right = "" },
        draw_empty = true,
      },
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {
      {
        "diff",
        symbols = {
          added = " ",
          modified = " ",
          removed = " ",
        },
        source = diff_source,
      },
    },
    lualine_y = {
      {
        "b:gitsigns_head",
        icon = { "" },
      },
    },
    lualine_z = {
      {
        "filesize",
        -- separator = { left = '║', right = '║' },
      },
    },
  },
  extensions = { "oil" },
})
--- }}}
