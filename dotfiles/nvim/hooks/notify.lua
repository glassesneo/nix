--- lua_source {{{
local notify = require("notify")
notify.setup({
  stages = "slide",
  max_width = 50,
  timeout = 1800,
})
vim.notify = notify
--- }}}
