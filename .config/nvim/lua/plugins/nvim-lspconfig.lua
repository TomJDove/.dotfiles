return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			vim.lsp.config("rust_analyzer", { capabilities = capabilities })
			vim.lsp.enable("rust_analyzer")

			vim.lsp.config("bashls", { capabilities = capabilities })
			vim.lsp.enable("bashls")

			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})
			vim.lsp.enable("lua_ls")

			-- Type script language server and linter
			vim.lsp.config("ts_ls", {})
			vim.lsp.enable("ts_ls")

			-- HTML
			vim.lsp.config("superhtml", {
				capabilities = capabilities,
			})
			vim.lsp.enable("superhtml")

			vim.diagnostic.config({
				underline = false, -- disables underlining entirely
				virtual_text = false, -- still show messages inline
				signs = true, -- keep signs in the gutter
				update_in_insert = false,
			})

			-- Enable basedpyright
			vim.lsp.config("basedpyright", {
				capabilities = capabilities,
				settings = {
					basedpyright = {
						-- Using Ruff's import organizer
						disableOrganizeImports = true,
					},
					python = {
						analysis = {
							-- Enable analysis for refactoring support, while Ruff handles linting
							typeCheckingMode = "basic",
						},
					},
				},
			})
			vim.lsp.enable("basedpyright")

			-- Enable ruff
			vim.lsp.config("ruff", {
				capabilities = capabilities,
			})
			vim.lsp.enable("ruff")

			-- Configure LSP capabilities for Python: ty for everything, BasedPyRight only for renaming
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp_attach_python_capabilities", { clear = true }),
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client == nil then
						return
					end
					if client.name == "ruff" then
						-- Disable hover in favor of ty
						client.server_capabilities.hoverProvider = false
					elseif client.name == "basedpyright" then
						-- Disable everything - let ty handle everything including renaming
						client.server_capabilities.hoverProvider = false
						client.server_capabilities.definitionProvider = false
						client.server_capabilities.referencesProvider = false
						client.server_capabilities.documentSymbolProvider = false
						client.server_capabilities.workspaceSymbolProvider = false
						client.server_capabilities.implementationProvider = false
						client.server_capabilities.typeDefinitionProvider = false
						client.server_capabilities.codeActionProvider = false
						client.server_capabilities.completionProvider = false
						client.server_capabilities.signatureHelpProvider = false
						client.server_capabilities.renameProvider = false
					end
				end,
				desc = "LSP: Configure Python LSP capabilities",
			})

			-- Enable ty
			vim.lsp.config("ty", {
				capabilities = capabilities,
				settings = {
					ty = {
						-- ty language server settings go here
					},
				},
			})
			vim.lsp.enable("ty")

			-- LSP key bindings
			vim.keymap.set("n", "gd", vim.lsp.buf.definition)
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })

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
