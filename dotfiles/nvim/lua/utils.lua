---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts? table
local map = function(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts or {})
end

---@param mode string|string[]
---@param lhs string
---@param opts? table
local unmap = function(mode, lhs, opts)
  vim.keymap.del(mode, lhs, opts or {})
end

---@param listPath string
---@return table
---@nodiscard
local load_plugin_list = function(listPath)
  local list = require(listPath)
  local plugins = {}
  for category, files in pairs(list) do
    for _, p in pairs(files) do
      local plugin_path = "plugins/" .. category .. "/" .. p
      table.insert(plugins, require(plugin_path))
    end
  end
  return plugins
end

return {
  map = map,
  unmap = unmap,
  load_plugin_list = load_plugin_list,
}
