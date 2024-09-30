--- lua_source {{{
local diff_source = function()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

---@return integer
local total_lines = function()
  return vim.fn.line("$")
end

local neofusion_lualine = require("neofusion.lualine")
local neofusion_palette = require("neofusion.palette")

require("lualine").setup({
  options = {
    section_separators = { left = "", right = "" },
    component_separators = { left = "", right = "" },
    globalstatus = true,
    theme = neofusion_lualine,
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
  tabline = {
    lualine_a = {
      {
        "buffers",
        mode = 4,
        symbols = {
          modified = "_",
          alternate_file = " ",
          directory = " ",
        },
        buffers_color = {
          active = {
            bg = neofusion_palette.bright_green,
            fg = neofusion_palette.dark4,
            gui = "bold",
          },
          inactive = neofusion_lualine.inactive.b,
        },
      },
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {
      {
        "datetime",
        style = "%m/%d(%A) %H:%M",
        color = {
          bg = neofusion_palette.dark_aqua,
          fg = neofusion_palette.bright_aqua,
        },
      },
    },
  },
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
        draw_empty = true,
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
        total_lines,
        color = { bg = "#fad600", fg = neofusion_palette.dark4 },
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
})
--- }}}
