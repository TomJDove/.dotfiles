return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			open_mapping = [[<c-\>]],
			direction = "float",
		},
		config = function(opts)
			toggleterm = require("toggleterm")
			toggleterm.setup(opts)

			Terminal = require("toggleterm.terminal").Terminal
			terminal = Terminal:new({ id = 1, direction = "float", name = "Terminal" })

			vim.keymap.set({ "n", "t" }, "\\t", function()
				terminal:toggle()
			end, { desc = "Toggle terminal" })
		end,
	},
}
