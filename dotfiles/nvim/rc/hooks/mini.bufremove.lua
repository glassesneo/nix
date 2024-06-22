--- lua_source {{{
local utils = require("utils")
local bufremove = require("mini.bufremove")
bufremove.setup({})

utils.map("n", "<Leader>bd", function()
  bufremove.delete(vim.api.nvim_get_current_buf())
end)
--- }}}
