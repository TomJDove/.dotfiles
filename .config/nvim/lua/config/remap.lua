-- Make the space bar the leader key
vim.g.mapleader = " "

-- Replace escape with kj
vim.keymap.set("i", "kj", "<Esc>")

-- Execute Lua
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>", { desc = "Run Lua (file)" })
vim.keymap.set("n", "<space>x", ":.lua<CR>", { desc = "Run Lua (line)" })
vim.keymap.set("v", "<space>x", ":lua<CR>", { desc = "Run Lua (selection)" })

vim.keymap.set("n", "<leader>D", "<CMD> NoiceDismiss <CR>", { desc = "Dismiss notification" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true })

-- Tmux sessionizer
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<M-h>", "<cmd>silent !tmux neww tmux-sessionizer -s 0<CR>")
-- vim.keymap.set("n", "<M-t>", "<cmd>silent !tmux neww tmux-sessionizer -s 1<CR>")
-- vim.keymap.set("n", "<M-n>", "<cmd>silent !tmux neww tmux-sessionizer -s 2<CR>")
-- vim.keymap.set("n", "<M-s>", "<cmd>silent !tmux neww tmux-sessionizer -s 3<CR>")
--

-- In the quickfix window, <CR> is used to jump to the error under the
-- cursor, so undefine the mapping there.
-- Added this because pressing enter in the quickfix window wasn't working as expected - it didn't
-- jump to the location in the file.
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "quickfix",
	callback = function()
		vim.keymap.set("n", "<CR>", "<CR>", { buffer = true })
	end,
})
