--- lua_source {{{
vim.fn["lexima#add_rule"]({
  char = ".",
  at = [[{\%#}]],
  input_after = ".",
  filetype = { "nim", "nims", "nimble" },
})
vim.fn["lexima#add_rule"]({
  char = ".",
  at = [[{\%#.}]],
  leave = 1,
  filetype = { "nim", "nims", "nimble" },
})
vim.fn["lexima#add_rule"]({
  char = "<BS>",
  at = [[{.\%#.}]],
  delete = 1,
  filetype = { "nim", "nims", "nimble" },
})
--- }}}
