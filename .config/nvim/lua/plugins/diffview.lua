return {
	{
		"sindrets/diffview.nvim",
		config = function()
			vim.keymap.set("n", "<leader>dvo", "<Cmd>DiffviewOpen<CR>")
			vim.keymap.set("n", "<leader>dvc", "<Cmd>DiffviewClose<CR>")
		end,
	},
}
