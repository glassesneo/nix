--- lua_add {{{
local notify = require("mini.notify")

notify.setup({
  lsp_progress = {
    enable = true,
    duration_last = 1500,
  },
})

vim.notify = notify.make_notify()
--- }}}
