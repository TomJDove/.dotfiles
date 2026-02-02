return {
	{
		"albertopfp/nvim-slack",
		enabled = false,
		dependencies = {
			"nvim-lua/plenary.nvim", -- Optional but recommended
		},
		config = function()
			require("nvim-slack").setup({
				token = "xapp-1-YOUR-APP-TOKEN",
			})
		end,
	},
}
