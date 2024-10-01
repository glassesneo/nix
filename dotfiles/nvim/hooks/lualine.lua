--- lua_source {{{
---@nodiscard
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

---@return string
local total_lines = function()
  return vim.fn.line("$") .. " lines"
end

local neofusion_lualine = require("neofusion.lualine")
local neofusion_palette = require("neofusion.palette")

require("lualine").setup({
  options = {
    -- section_separators = { left = "", right = "" },
    component_separators = { left = "", right = "" },
    section_separators = {},
    -- component_separators = {},
    globalstatus = true,
    theme = neofusion_lualine,
    disabled_filetypes = {
      "ddu-filer",
    },
  },
  sections = {
    lualine_a = {
      {
        "mode",
      },
      {
        "b:gitsigns_head",
        icon = {
          "",
          color = {
            fg = "#ffba4f",
            bg = "NONE",
          },
        },
        color = {
          fg = neofusion_palette.bright_aqua,
          bg = "NONE",
        },
      },
    },
    lualine_b = {
      {
        "filename",
        newfile_status = true,
        path = 4,
        shorting_target = 30,
        symbols = {
          modified = "_",
          readonly = " ",
          newfile = "󰘩 ",
        },
        color = {
          bg = "NONE",
        },
      },
    },
    lualine_c = {
      {
        "navic",
        color = {
          bg = "NONE",
        },
      },
    },
    lualine_x = {
      {
        "encoding",
        color = {
          bg = "NONE",
        },
      },
    },
    lualine_y = {
      {
        "searchcount",
        draw_empty = true,
        color = {
          bg = "NONE",
        },
      },
    },
    lualine_z = {
      {
        "filetype",
        color = {
          bg = "NONE",
        },
      },
      {
        "datetime",
        style = "%m/%d(%A) %H:%M",
        color = {
          bg = "NONE",
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
        draw_empty = true,
        color = {
          bg = "NONE",
          fg = neofusion_palette.bright_aqua,
        },
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
    lualine_y = {},
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
    lualine_y = {},
    lualine_z = {
      {
        "filesize",
        -- separator = { left = '║', right = '║' },
      },
    },
  },
})

vim.cmd("highlight lualine_c_normal guibg=NONE")
vim.cmd("highlight lualine_c_inactive guibg=NONE")
vim.o.showmode = false

-- require("transparent").clear_prefix("lualine")
--- }}}
