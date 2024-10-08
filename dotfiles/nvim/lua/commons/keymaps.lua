local utils = require("utils")

vim.g.mapleader = " "
utils.map("i", "jj", [[<ESC>]], { silent = true })
utils.map("t", "jj", [[<C-\><C-n>]], { silent = true })
utils.map("n", "<S-h>", vim.cmd["bprev"], { silent = true })
utils.map("n", "<S-l>", vim.cmd["bnext"], { silent = true })
utils.map("n", "q", [[<Nop>]])
utils.map("n", "<S-Y>", [[y$]], { silent = true })
utils.map("n", "x", [["_d]], { silent = true })
utils.map("n", "X", [["_D]], { silent = true })
utils.map("n", "<leader>r", 'yiw:%s/<C-r><C-r>"//g<Left><Left>', { silent = true })
utils.map("x", "<leader>r", 'y:%s/<C-r><C-r>"//g<Left><Left>', { silent = true })
utils.map({ "n", "v" }, "j", [[gj]], { silent = true })
utils.map({ "n", "v" }, "k", [[gk]], { silent = true })
utils.map({ "n", "v" }, "M", [[%]], { silent = true })
utils.map({ "n", "v" }, "<C-h>", "[(", { silent = true })
utils.map({ "n", "v" }, "<C-l>", "])", { silent = true })
utils.map({ "n", "v", "o" }, "<Leader>h", [[^]], { silent = true })
utils.map({ "n", "v", "o" }, "<Leader>l", [[$]], { silent = true })
utils.map({ "n" }, "<Leader>w", vim.cmd["w"], { silent = true })
utils.map("x", "x", [["_x]], { silent = true })
utils.map("o", "x", [[d]], { silent = true })
utils.map("x", "y", [[mzy`z]], { silent = true })
utils.map("x", "d", [[mzd`z]], { silent = true })
utils.map("x", "gc", [[mzgc`z]], { silent = true })
