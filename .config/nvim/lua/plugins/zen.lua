return {
	{
		"folke/zen-mode.nvim",
		opts = {
			window = {
				width = 127, -- 120 chars plus sidebar for line numebrs and diagnostic signs
				options = {
					number = true,
					relativenumber = true,
					signcolumn = "yes",
				},
			},
		},
		keys = {
			{ "<leader>z", "<CMD>ZenMode<CR>", desc = "Zen mode" },
		},
	},
}
