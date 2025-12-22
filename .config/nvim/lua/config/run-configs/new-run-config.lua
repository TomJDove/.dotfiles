local configs = require("config.run-configs.configs")
local json = require("cjson")

function save_config_file(configs, filepath)
	filepath = filepath or vim.fn.getcwd() .. "/run_configs.json"

	local encoded = vim.fn.json_encode(configs)
	local lines = vim.split(encoded, "\n")

	local ok = pcall(vim.fn.writefile, lines, filepath)
	if not ok then
		vim.notify("Failed to write config file", vim.log.levels.ERROR)
		return false
	end

	return true
end

function add_new_config()
	local new_config = {}

	-- Prompt for name
	vim.ui.input({ prompt = "Config name: " }, function(name)
		if not name or name == "" then
			return
		end
		new_config.name = name

		-- Prompt for script
		vim.ui.input({
			prompt = "Script path: ",
			default = vim.fn.getcwd() .. "/",
			completion = "file",
		}, function(script)
			if not script or script == "" then
				return
			end
			new_config.script = script

			-- Prompt for parameters (optional)
			vim.ui.input({
				prompt = "Parameters (optional): ",
			}, function(parameters)
				new_config.parameters = parameters or ""

				-- Prompt for working directory (optional)
				vim.ui.input({
					prompt = "Working directory (optional): ",
					completion = "dir",
				}, function(working_dir)
					new_config.working_directory = working_dir or vim.fn.getcwd()

					-- Save the config
					local filepath = vim.fn.getcwd() .. "/run_configs.json"
					local configs = get_cached_config()
					table.insert(configs, new_config)

					if save_config_file(configs, filepath) then
						vim.notify("Config '" .. new_config.name .. "' added successfully!", vim.log.levels.INFO)
					end
				end)
			end)
		end)
	end)
end

-- Add new run config
vim.keymap.set("n", "<leader>ra", add_new_config, { desc = "Add run config" })
