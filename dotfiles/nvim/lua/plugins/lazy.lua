local utils = require('utils')

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

local plugins = utils.load_plugin_list('plugins/list')

require('lazy').setup(plugins, {
  checker = {
    enabled = true,
  },
  defaults = {
    lazy = true
  },
})
