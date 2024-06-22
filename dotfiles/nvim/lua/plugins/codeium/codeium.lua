local config = function()
  vim.g.codeium_disable_bindings = 1
  vim.g.codeium_manual = true
  vim.g.codeium_render = false
end

return {
  "Exafunction/codeium.vim",
  event = "BufEnter",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = config,
  commit = "cec5865",
}
