return {
	{
		"mrjones2014/smart-splits.nvim",
		lazy = false,
		build = "./kitty/install-kittens.bash",
		config = function()
			-- Kitty integration
			require("smart-splits").setup({ multiplexer_integration = "kitty" })

			-- Move between splits
			vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
			vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
			vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
			vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)

			-- Resize splits with Ctrl-w + arrow keys
			vim.keymap.set("n", "<C-w><Up>", require("smart-splits").resize_up)
			vim.keymap.set("n", "<C-w><Down>", require("smart-splits").resize_down)
			vim.keymap.set("n", "<C-w><Left>", require("smart-splits").resize_left)
			vim.keymap.set("n", "<C-w><Right>", require("smart-splits").resize_right)
		end,
	},
}
