return {
	{
		"neanias/everforest-nvim",
		version = false,
		lazy = false,
		priority = 1000,
		config = function()
			require("everforest").setup({
				background = "medium",
				transparent_background_level = 2, -- 0 (default), 1 (partial), or 2 (full)
			})
			vim.cmd.colorscheme("everforest")
		end,
	},
}
