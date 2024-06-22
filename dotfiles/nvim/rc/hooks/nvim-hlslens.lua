--- lua_add {{{
local utils = require("utils")

local hlslens = require("hlslens")
hlslens.setup()

local kopts = { noremap = true, silent = true }

utils.map("n", "n", function()
  vim.fn.execute("normal! " .. vim.api.nvim_get_vvar("count1") .. "n")
  hlslens.start()
end, kopts)

utils.map("n", "<S-n>", function()
  vim.fn.execute("normal! " .. vim.api.nvim_get_vvar("count1") .. "<S-n>")
  hlslens.start()
end, kopts)

utils.map("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
utils.map("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
utils.map("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
utils.map("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
--- }}}
