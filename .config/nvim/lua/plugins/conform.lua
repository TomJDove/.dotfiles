return {
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local conform = require("conform")
			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "ruff_format" },
					rust = { "rustfmt" },
					markdown = { "prettierd" },
					json = { "prettierd" },
					yaml = { "prettierd" },
				},
				format_on_save = {
					lsp_fallback = true,
					timeout_ms = 500,
				},
			})
		end,
	},
}
