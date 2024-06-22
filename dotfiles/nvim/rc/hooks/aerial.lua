--- lua_source {{{
local utils = require("utils")
require("aerial").setup({
  backends = { "treesitter", "lsp", "markdown", "man" },
  layout = {
    max_width = 50,
    width = 30,
    min_width = 25,
    default_direction = "left",
    placement = "edge",
  },
  keymaps = {
    ["<CR>"] = "actions.close",
    ["q"] = "actions.close",
    ["l"] = "actions.tree_open",
    ["L"] = "actions.tree_open_recursive",
    ["h"] = "actions.tree_close",
    ["H"] = "actions.tree_close_recursive",
  },
  autojump = true,
  lsp = {
    -- If true, fetch document symbols when LSP diagnostics update.
    diagnostics_trigger_update = true,

    -- Set to false to not update the symbols when there are LSP errors
    update_when_errors = true,

    -- How long to wait (in ms) after a buffer change before updating
    -- Only used when diagnostics_trigger_update = false
    update_delay = 300,

    -- Map of LSP client name to priority. Default value is 10.
    -- Clients with higher (larger) priority will be used before those with lower priority.
    -- Set to -1 to never use the client.
    priority = {
      -- pyright = 10,
    },
  },
})

utils.map("n", "<Space>a", "<Cmd>AerialOpen<CR>")

--- }}}
