local utils = require('utils')

local config = function ()
  require('dial').setup({})
  utils.map('n', '<C-a>', function ()
    require('dial.map').manipulate('increment', 'normal')
  end)
  utils.map('n', '<C-x>', function ()
    require('dial.map').manipulate('decrement', 'normal')
  end)
  utils.map('n', 'g<C-a>', function ()
    require('dial.map').manipulate('increment', 'gnormal')
  end)
  utils.map('n', 'g<C-x>', function ()
    require('dial.map').manipulate('decrement', 'gnormal')
  end)
  utils.map('v', '<C-a>', function ()
    require('dial.map').manipulate('increment', 'visual')
  end)
  utils.map('v', '<C-x>', function ()
    require('dial.map').manipulate('decrement', 'visual')
  end)
  utils.map('v', 'g<C-a>', function ()
    require('dial.map').manipulate('increment', 'gvisual')
  end)
  utils.map('v', 'g<C-x>', function ()
    require('dial.map').manipulate('decrement', 'gvisual')
  end)
end

return {
  'monaqa/dial.nvim',
  keys = {
    {'<C-a>', mode = {'n', 'v'}},
    {'<C-x>', mode = {'n', 'v'}},
    {'g<C-a>', mode = {'n', 'v'}},
    {'g<C-x>', mode = {'n', 'v'}},
  },
  config = config,
}
