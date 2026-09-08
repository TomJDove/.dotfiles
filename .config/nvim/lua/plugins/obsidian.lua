return {
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		-- ft = "markdown",
		-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
		event = {
			-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
			-- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
			-- refer to `:h file-pattern` for more examples
			"BufReadPre "
				.. vim.fn.expand("~")
				.. "/notes/work/*.md",
			"BufNewFile " .. vim.fn.expand("~") .. "/notes/work/*.md",
			"BufReadPre " .. vim.fn.expand("~") .. "/notes/personal-notes/*.md",
			"BufNewFile " .. vim.fn.expand("~") .. "/notes/personal-notes/*.md",
		},
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",
		},
		opts = {
			ui = {
				enable = false,
				checkboxes = {
					[" "] = { char = "☐", hl_group = "ObsidianTodo" },
					["x"] = { char = "✔", hl_group = "ObsidianDone" },
				},
			},
			workspaces = {
				{
					name = "personal",
					path = "~/notes/personal-notes",
				},
				{
					name = "work",
					path = "~/notes/work",
				},
			},
			daily_notes = {
				folder = "daily",
				date_format = "%Y-%m-%d-%a",
				template = "templates/daily.md",
			},
			templates = {
				folder = "templates",
				date_format = "%Y-%m-%d",
				time_format = "%H:%M",
			},
			---@param url string
			follow_url_func = function(url)
				vim.ui.open(url)
			end,
		},
		keys = {
			{ "<leader>ot", "<cmd>ObsidianToday<CR>", desc = "Daily note (today)" },
			{ "<leader>o+", "<cmd>ObsidianTomorrow<CR>", desc = "Daily note (tomorrow)" },
			{ "<leader>o-", "<cmd>ObsidianYesterday<CR>", desc = "Daily note (yesterday)" },
			{ "<leader>on", "<cmd>ObsidianNew<CR>", desc = "New" },
			{ "<leader>or", "<cmd>ObsidianRename<CR>", desc = "Rename" },
			{ "<leader>oP", "<cmd>ObsidianPasteImg<CR>", desc = "Paste image" },
			{ "<leader>oT", "<cmd>ObsidianTags<CR>", desc = "Tags" },
			{ "<leader>om", "<cmd>ObsidianTemplate<CR>", desc = "Insert template" },
			{ "<leader>ob", "<cmd>ObsidianBacklinks<CR>", desc = "Backlinks" },
			{ "<leader>oc", "<cmd>ObsidianTOC<CR>", desc = "Insert ToC" },
			{ "<leader>ox", "<cmd>ObsidianExtractNote<CR>", desc = "Extract note", mode = "v" },
		},
	},
}
