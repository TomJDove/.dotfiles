return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					accept = false, -- We'll set up Tab manually below
					accept_word = "<M-w>",
					accept_line = "<M-l>",
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
			},
			panel = { enabled = true },
		},
		config = function(_, opts)
			require("copilot").setup(opts)

			-- Smart Tab: accept Copilot suggestion if visible, otherwise use default Tab
			vim.keymap.set("i", "<Tab>", function()
				if require("copilot.suggestion").is_visible() then
					require("copilot.suggestion").accept()
				else
					return "<Tab>"
				end
			end, { expr = true, silent = true })
		end,
	},
}
