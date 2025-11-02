return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			local lsp_config = require("lspconfig")

			lsp_config.rust_analyzer.setup({})

			-- Type script language server and linter
			lsp_config.ts_ls.setup({})
			--
			-- lsp_config.harper_ls.setup({
			-- 	settings = {
			-- 		dialect = "Australian",
			-- 	},
			-- })
			--
			vim.diagnostic.config({
				underline = false, -- disables underlining entirely
				virtual_text = false, -- still show messages inline
				signs = true, -- keep signs in the gutter
				update_in_insert = false,
			})

			lsp_config.basedpyright.setup({
				settings = {
					basedpyright = {
						-- Using Ruff's import organizer
						disableOrganizeImports = true,
					},
					python = {
						analysis = {
							-- Ignore all files for analysis to exclusively use Ruff for linting
							typeCheckingMode = "off",
							ignore = { "*" },
						},
					},
				},
			})

			lsp_config.ruff.setup({ capabilities = capabilities })

			-- Disable hover for Ruff
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client == nil then
						return
					end
					if client.name == "ruff" then
						-- Disable hover in favor of Pyright
						client.server_capabilities.hoverProvider = false
					end
				end,
				desc = "LSP: Disable hover capability from Ruff",
			})

			-- LSP key bindings
			vim.keymap.set("n", "gd", vim.lsp.buf.definition)

			-- Diagnostic key bindings
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set(
				"n",
				"<leader>do",
				vim.diagnostic.open_float,
				{ noremap = true, silent = true, desc = "Show diagnostics" }
			)
			vim.keymap.set(
				"n",
				"<leader>dk",
				vim.diagnostic.goto_prev,
				{ noremap = true, silent = true, desc = "Previous diagnostic" }
			)
			vim.keymap.set(
				"n",
				"<leader>dj",
				vim.diagnostic.goto_next,
				{ noremap = true, silent = true, desc = "Next diagnostic" }
			)
			vim.keymap.set(
				"n",
				"<leader>dq",
				vim.diagnostic.setqflist,
				{ noremap = true, silent = true, desc = "Diagnostic quickfix" }
			)
		end,
	},
}
