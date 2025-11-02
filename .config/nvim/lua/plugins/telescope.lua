return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			require("telescope").setup({
				pickers = {
					find_files = {},
				},
				extensions = {
					fzf = {},
				},
			})

			require("telescope").load_extension("fzf")
			-- require("telescope").load_extension("noice")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
			vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Find diagnostics" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help" })
			vim.keymap.set("n", "<leader>f.", function()
				require("telescope.builtin").lsp_document_symbols({ symbols = "function" })
			end, { desc = "Find functions in file" })
			vim.keymap.set("n", "<leader>en", function()
				require("telescope.builtin").find_files({
					cwd = vim.fn.stdpath("config"),
				})
			end, { desc = "Find in config" })

			require("config.telescope.multigrep").setup()
		end,
	},
}
