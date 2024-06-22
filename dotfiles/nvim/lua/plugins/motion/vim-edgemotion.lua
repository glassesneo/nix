local utils = require('utils')

local config = function ()
  utils.map({'n', 'v'}, '<C-j>', '<Plug>(edgemotion-j)')
  utils.map({'n', 'v'}, '<C-k>', '<Plug>(edgemotion-k)')
end

return {
  'haya14busa/vim-edgemotion',
  keys = {
    {'<C-j>', mode = {'n', 'v'}},
    {'<C-k>', mode = {'n', 'v'}},
  },
  config = config
}
