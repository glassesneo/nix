--- lua_source {{{
local utils = require("utils")

local ls = require("luasnip")
ls.setup()
require("luasnip.loaders.from_lua").lazy_load({ paths = { "$BASE_DIR/snippet/LuaSnip.lua" } })

utils.map({ "i", "s" }, "<C-l>", function()
  ls.jump(1)
end, { silent = true })
utils.map({ "i", "s" }, "<C-h>", function()
  ls.jump(-1)
end, { silent = true })
--- }}}
