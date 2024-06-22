--- lua_source {{{
-- highlight
vim.api.nvim_create_augroup('qs_colors', {})
vim.api.nvim_create_autocmd('colorscheme', {
  group = 'qs_colors',
  command = [[highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline]]
})
vim.api.nvim_create_autocmd('colorscheme', {
  group = 'qs_colors',
  command = [[highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline]]
})
--- }}}
