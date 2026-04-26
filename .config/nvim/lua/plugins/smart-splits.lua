return {
	{
		"mrjones2014/smart-splits.nvim",
		lazy = false,
		build = "./kitty/install-kittens.bash",
		config = function()
			-- Kitty integration
			require("smart-splits").setup({ multiplexer_integration = "kitty" })

			vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
			vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
			vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
			vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)
		end,
	},
}
