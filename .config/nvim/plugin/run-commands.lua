local terminal = require("toggleterm")
local json = require("cjson")

Terminal = require("toggleterm.terminal").Terminal
local run_terminal = Terminal:new({ id = 2, direction = "float", name = "Run" })

function read_config_file(filepath)
	filepath = filepath or vim.fn.getcwd() .. "/run_configs.json"
	local config_file = assert(io.open(filepath, "r"), "No config file found")
	local content = config_file:read("*a")
	config_file:close()
	return json.decode(content)
end

function create_preview(config)
	local preview_string = [[
Name: %s

File: %s

Input parameters: %s

Output directory: %s
]]
	local text = string.format(preview_string, config.name, config.file, config.input_parameters, config.output_dir)
	return { text = text }
end

function make_absolute_path(path)
	if string.sub(path, 1, 1) == "/" then
		return path
	end
	return vim.fn.getcwd() .. "/" .. path
end

function process_config(config)
	config.command = config.command or "uv run"
	config.working_directory = config.working_directory or vim.fn.getcwd()
	config.file = config.file or ""
end

function create_command(config)
	process_config(config)
	full_command = {
		config.command,
		config.file,
		"--input-parameters",
		config.input_parameters,
		"--output-dir",
		config.output_dir,
	}
	return table.concat(full_command, " ")
end

function create_action(config)
	return function()
		local command = create_command(config)
		run_terminal:toggle()
		run_terminal:send(command, false)
	end
end

function get_run_items()
	local items = {}
	local run_configs = read_config_file()
	for index, config in ipairs(run_configs) do
		local item = {
			idx = idx,
			name = config.name,
			preview = create_preview(config),
			action = create_action(config),
		}
		table.insert(items, item)
	end
	return items
end

function show_commands()
	Snacks.picker({
		title = "Run Configs",
		layout = {
			preset = "default",
			preview = true,
		},
		preview = Snacks.picker.preview.preview,
		items = get_run_items(),
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

-- Toggle run terminal
vim.keymap.set({ "n", "t" }, "\\r", function()
	run_terminal:toggle()
end, { desc = "Toggle run terminal" })

-- Run command window
vim.keymap.set("n", "<leader>r", show_commands, { desc = "Run" })
