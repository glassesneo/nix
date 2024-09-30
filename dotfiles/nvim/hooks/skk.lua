--- lua_add {{{
local utils = require("utils")
utils.map({ "i" }, "<C-j>", "<Plug>(skkeleton-enable)")
utils.map({ "i" }, "<C-l>", "<Plug>(skkeleton-disable)")
--- }}}

--- lua_source {{{
vim.fn["skkeleton#config"]({
  globalDictionaries = { "$HOME/.config/skk/SKK-JISYO.L" },
  eggLikeNewline = true,
  userDictionary = "$HOME/.config/.skkeleton",
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

require("skkeleton_indicator").setup({
  border = "single",
  fadeOutMs = 1200,
  eijiText = "en",
})
--- }}}

