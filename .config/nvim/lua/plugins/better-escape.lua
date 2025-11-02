return {
	{
		"max397574/better-escape.nvim",
		config = function()
			require("better_escape").setup({
				timeout = vim.o.timeoutlen, -- after `timeout` passes, you can press the escape key and the plugin will ignore it
				default_mappings = false,
				mappings = { i = { k = { j = "<Esc>" } } },
			})
		end,
	},
}
