--- lua_add {{{
local utils = require("utils")
utils.map({ "i" }, "<C-j>", "<Plug>(skkeleton-enable)")
utils.map({ "i" }, "<C-l>", "<Plug>(skkeleton-disable)")
--- }}}

--- lua_source {{{
vim.fn["skkeleton#config"]({
  globalDictionaries = { "~/.config/skk/SKK-JISYO.L" },
  eggLikeNewline = true,
  userDictionary = "~/.config/.skkeleton"
})
vim.fn["skkeleton#register_keymap"]("input", ":", "henkanPoint")
vim.fn["skkeleton#register_kanatable"]("rom", {
  l = false,
  la = { "ぁ" },
  li = { "ぃ" },
  lu = { "ぅ" },
  le = { "ぇ" },
  lo = { "ぉ" },
  lya = { "ゃ" },
  lyu = { "ゅ" },
  lyo = { "ょ" },
})
-- table.insert(vim.g["skkeleton#mapped_keys"], "<C-l>")
--- }}}
