require("commons/autocmd")
require("commons/highlights")
require("commons/keymaps")
require("commons/options")

-- require("os").setlocale("C")
vim.env.LANG = "en_US.UTF-8"

-- vim.env.BASE_DIR = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")
vim.env.BASE_DIR = "~/.config/nvim/rc"

local dpp_src = "~/.cache/dpp/repos/github.com/Shougo/dpp.vim"
local denops_src = "~/.cache/dpp/repos/github.com/vim-denops/denops.vim"

vim.opt.runtimepath:prepend(dpp_src)
local dpp = require("dpp")

local dpp_base = "~/.cache/dpp"
local dpp_config = "$BASE_DIR/dpp_config.ts"

local ext_toml = "~/.cache/dpp/repos/github.com/Shougo/dpp-ext-toml"
local ext_lazy = "~/.cache/dpp/repos/github.com/Shougo/dpp-ext-lazy"
local ext_installer = "~/.cache/dpp/repos/github.com/Shougo/dpp-ext-installer"
local ext_git = "~/.cache/dpp/repos/github.com/Shougo/dpp-protocol-git"

vim.opt.runtimepath:append(ext_toml)
vim.opt.runtimepath:append(ext_git)
vim.opt.runtimepath:append(ext_lazy)
vim.opt.runtimepath:append(ext_installer)

-- vim.g.denops_server_addr = "127.0.0.1:32121"
vim.g["denops#debug"] = 1

if dpp.load_state(dpp_base) then
  vim.opt.runtimepath:prepend(denops_src)

  vim.api.nvim_create_autocmd("User", {
    pattern = "DenopsReady",
    callback = function()
      vim.notify("vim load_state is failed")
      dpp.make_state(dpp_base, dpp_config)
    end,
  })
end

vim.api.nvim_create_autocmd("User", {
  pattern = "Dpp:makeStatePost",
  callback = function()
    vim.notify("dpp make_state() is done")
  end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "init.lua", "$BASE_DIR/hooks/*.lua", "$BASE_DIR/*.toml", "$BASE_DIR/*.ts" },
  callback = function()
    dpp.check_files()
  end,
})

--- install
vim.api.nvim_create_user_command("DppInstall", "call dpp#async_ext_action('installer', 'install')", {})

-- update
vim.api.nvim_create_user_command("DppUpdate", function(opts)
  local args = opts.fargs
  vim.fn["dpp#async_ext_action"]("installer", "update", { names = args })
end, { nargs = "*" })

-- check update
vim.api.nvim_create_user_command("DppCheckUpdate", "call dpp#async_ext_action('installer', 'checkNotUpdated')", {})

vim.api.nvim_create_user_command("DppClearState", "call dpp#clear_state()", {})

-- vim.lsp.set_log_level("debug")
