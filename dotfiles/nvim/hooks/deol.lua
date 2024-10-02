--- lua_source {{{
local utils = require("utils")

vim.g["deol#floating_border"] = "rounded"
utils.map("n", "<Leader>d", function()
  vim.fn["deol#start"]({
    split = "farright",
    start_insert = false,
    toggle = false,
    winwidth = 45,
  })
end)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "deol",
  callback = function()
    utils.map("n", "q", "<Plug>(deol_quit)")
  end,
})
--- }}}
