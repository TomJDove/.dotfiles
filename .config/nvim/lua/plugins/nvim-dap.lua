return {
	{
		"mfussenegger/nvim-dap",
		enabled = true,
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"mfussenegger/nvim-dap-python",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
		},
		config = function()
			local dap = require("dap")
			local ui = require("dapui")

			require("dapui").setup({
				layouts = {
					-- Layout 1: REPL on right only
					{
						elements = {
							{ id = "repl", size = 1.0 },
						},
						size = 0.40,
						position = "right",
					},
					-- Layout 2: BP on left, REPL on bottom
					{
						elements = {
							{ id = "breakpoints", size = 1.0 },
						},
						size = 0.15,
						position = "left",
					},
					{
						elements = {
							{ id = "repl", size = 1.0 },
						},
						size = 0.30,
						position = "bottom",
					},
				},
			})

			-- Toggle between layouts
			local current_layout = 1
			vim.keymap.set("n", "<leader>ds", function()
				ui.close()
				if current_layout == 1 then
					ui.open({ layout = 2 })
					ui.open({ layout = 3 })
					current_layout = 2
				else
					ui.open({ layout = 1 })
					current_layout = 1
				end
			end, { desc = "DAP switch layout" })

			require("dap-python").setup("uv")

			-- Set justMyCode = False for Python configs
			for _, config in pairs(dap.configurations.python) do
				config.justMyCode = false
			end

			-- Rust configuration using codelldb
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = vim.fn.exepath("codelldb"),
					args = { "--port", "${port}" },
				},
			}

			dap.configurations.rust = {
				{
					name = "Launch",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = {},
				},
				{
					name = "Launch with arguments",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					args = function()
						local args_string = vim.fn.input("Arguments: ")
						return vim.split(args_string, " ")
					end,
				},
			}

			require("nvim-dap-virtual-text").setup({
				display_callback = function(variable)
					local name = string.lower(variable.name)
					local value = string.lower(variable.value)
					if #variable.value > 15 then
						return " " .. string.sub(variable.value, 1, 15) .. "... "
					end

					return " " .. variable.value
				end,
			})

			vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
			vim.keymap.set("n", "<space>gb", dap.run_to_cursor)

			-- Eval var under cursor
			vim.keymap.set("n", "<space>?", function()
				require("dapui").eval(nil, { enter = true })
			end)

			-- Test current method with pytest
			vim.keymap.set("n", "<leader>tm", function()
				require("dap-python").test_method({ justMyCode = false })
			end)

			vim.keymap.set("n", "<F9>", dap.continue)
			vim.keymap.set("n", "<F7>", dap.step_into)
			vim.keymap.set("n", "<F8>", dap.step_over)
			vim.keymap.set("n", "<S-F8>", dap.step_out)
			vim.keymap.set("n", "<F10>", dap.restart)
			vim.keymap.set("n", "<F12>", dap.terminate)

			-- Move up and down the stack
			vim.keymap.set("n", "<C-S-j>", function()
				require("dap").down()
			end)
			vim.keymap.set("n", "<C-S-k>", function()
				require("dap").up()
			end)

			dap.listeners.before.attach.dapui_config = function()
				ui.open({ layout = 1 })
			end
			dap.listeners.before.launch.dapui_config = function()
				ui.open({ layout = 1 })
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				ui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				ui.close()
			end
		end,
	},
}
