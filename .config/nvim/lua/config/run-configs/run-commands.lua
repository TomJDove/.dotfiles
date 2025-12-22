local config = require("config.run-configs.run-configs")
local json = require("cjson")

local M = {}

Terminal = require("toggleterm.terminal").Terminal
M.run_terminal = Terminal:new({ id = 2, direction = "float", name = "Run" })

local function create_preview(config)
	local preview_string = [[
Name: %s

Script: %s

Parameters: %s

Working directory: %s

]]
	local text = string.format(preview_string, config.name, config.script, config.parameters, config.working_directory)
	return { text = text }
end

local function make_absolute_path(path)
	if string.sub(path, 1, 1) == "/" then
		return path
	end
	return vim.fn.getcwd() .. "/" .. path
end

local function process_config(config)
	config.working_directory = config.working_directory or vim.fn.getcwd()
	config.script = make_absolute_path(config.script) or ""
	config.parameters = config.parameters or ""
end

local function create_command(config)
	process_config(config)
	full_command = {
		"uv run",
		"--project",
		vim.fn.getcwd(),
		"--directory",
		config.working_directory,
		config.script,
		config.parameters,
	}
	return table.concat(full_command, " ")
end

local function create_debug_command(config)
	process_config(config)
	full_command = {
		"uv run",
		"--project",
		vim.fn.getcwd(),
		"--directory",
		config.working_directory,
		"--with debugpy python -m",
		"debugpy --listen 127.0.0.1:1234 --wait-for-client",
		config.script,
		config.parameters,
	}
	return table.concat(full_command, " ")
end

local function create_action(config)
	return function()
		local command = create_command(config)
		M.run_terminal:toggle()
		M.run_terminal:send(command, false)
	end
end

local function create_debug_action(config)
	return function()
		local command = create_debug_command(config)
		M.run_terminal:send(command, false)

		vim.defer_fn(function()
			require("dap").run({
				name = "Attach to debugpy",
				type = "python",
				request = "attach",
				connect = {
					host = "127.0.0.1",
					port = 1234,
				},
				justMyCode = false,
			})
		end, 1000)
	end
end

local function get_run_items(debug)
	local items = {}
	local run_configs = config.get_cached_config()

	if not run_configs then
		vim.notify("No run configurations found.", vim.log.levels.WARN)
		return items
	end

	for index, config in ipairs(run_configs) do
		local item = {
			idx = idx,
			name = config.name,
			preview = create_preview(config),
			action = debug and create_debug_action(config) or create_action(config),
		}
		table.insert(items, item)
	end
	return items
end

function M.run_script(debug)
	Snacks.picker({
		title = "Run Configs",
		layout = {
			preset = "default",
			preview = true,
		},
		preview = Snacks.picker.preview.preview,
		items = get_run_items(debug),
		format = function(item, _)
			return {
				{ item.name, item.text_hl },
			}
		end,
		confirm = function(picker, item)
			return picker:norm(function()
				picker:close()
				item.action()
			end)
		end,
	})
end

M.setup = function()
	vim.keymap.set("n", "<leader>rr", function()
		M.run_script(false)
	end, { desc = "Run Script" })

	vim.keymap.set("n", "<leader>rd", function()
		M.run_script(true)
	end, { desc = "Debug Script" })

	vim.keymap.set({ "n", "t", "i" }, "\\r", function()
		M.run_terminal:toggle()
	end, { desc = "Toggle run terminal" })
end

return M
