local config = function ()
  vim.g['firenvim_config'] = {
    localSettings = {
      ['.*'] = {
        selector = 'textarea, div[role="textbox"]',
        priority = 0,
      }
    }
  }
end

return {
  'glacambre/firenvim',
  -- Lazy load firenvim
  -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
  lazy = not vim.g.started_by_firenvim,
  build = function ()
      vim.fn["firenvim#install"](0)
  end,
  config = config,
}
