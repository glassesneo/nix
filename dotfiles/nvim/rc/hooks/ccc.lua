--- lua_add {{{
local utils = require("utils")

utils.map("n", "<Leader>c", "<Cmd>CccPick<CR>")
--- }}}
--- lua_source {{{
require("ccc").setup({
  win_opts = {
    border = "rounded",
  },
  save_on_quit = true,
  highlighter = {
    auto_enable = true,
    max_byte = 100 * 1024,
    lsp = true,
  },
})
--- }}}
