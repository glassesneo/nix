--- lua_source {{{
require("hlchunk").setup({
  indent = {
    use_treesitter = true,
    chars = { "│", "¦" },

    style = {
      "#386b3d",
    },
  },
  blank = {
    enable = false,
  },
  chunk = {
    enable = true,
    use_treesitter = true,
    chars = {
      horizontal_line = "─",
      vertical_line = "│",
      left_top = "┌",
      left_bottom = "└",
      right_arrow = ">",
    },

    style = "#00ffff",
  },
  line_num = {
    enable = true,
    use_treesitter = true,
    style = "#138b20",
  },
})
--- }}}
