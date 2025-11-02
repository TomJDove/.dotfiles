-- Make the space bar the leader key
vim.g.mapleader = " "

-- Replace escape with kj
vim.keymap.set("i", "kj", "<Esc>")

-- Execute Lua
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>", { desc = "Run Lua (file)" })
vim.keymap.set("n", "<space>x", ":.lua<CR>", { desc = "Run Lua (line)" })
vim.keymap.set("v", "<space>x", ":lua<CR>", { desc = "Run Lua (selection)" })

vim.keymap.set("n", "<leader>D", "<CMD> NoiceDismiss <CR>", { desc = "Dismiss notification" })

-- Substitute
vim.keymap.set("n", "s", require("substitute").operator, { noremap = true })
vim.keymap.set("n", "ss", require("substitute").line, { noremap = true })
vim.keymap.set("n", "S", require("substitute").eol, { noremap = true })
vim.keymap.set("x", "s", require("substitute").visual, { noremap = true })

vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true })
