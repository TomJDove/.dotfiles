return {
	{
		"tamton-aquib/duck.nvim",
		config = function()
			vim.keymap.set("n", "<leader>dd", function()
				require("duck").hatch()
			end, { desc = "Hatch duck" })
			vim.keymap.set("n", "<leader>da", function()
				require("duck").cook_all()
			end, { desc = "Cook ducks" })
		end,
	},
}
