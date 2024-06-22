--- lua_source {{{
local utils = require("utils")

vim.g["deol#floating_border"] = "rounded"
utils.map("n", "<Leader>d", function()
  vim.fn["deol#start"]({
    split = "farright",
    -- start_insert = true,
    toggle = true,
    winwidth = 45,
  })
end)
--- }}}
