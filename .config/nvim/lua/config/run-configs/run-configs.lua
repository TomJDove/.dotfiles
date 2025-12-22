local json = require("cjson")

local M = {}

local cached_config = nil
local config_filepath = nil
local fs_watch = nil

local function read_config_file(filepath)
	filepath = filepath or vim.fn.getcwd() .. "/run_configs.json"
	local config_file = io.open(filepath, "r")
	if not config_file then
		return nil
	end
	local content = config_file:read("*a")
	config_file:close()
	return json.decode(content)
end

local function setup_file_watcher(filepath)
	-- Clean up existing watcher
	if fs_watch then
		fs_watch:stop()
		fs_watch = nil
	end

	-- Create new watcher
	fs_watch = vim.loop.new_fs_event()
	if fs_watch then
		fs_watch:start(
			filepath,
			{},
			vim.schedule_wrap(function(err, filename, events)
				if err then
					return
				end
				-- Reload config when file changes
				cached_config = read_config_file(filepath)
				vim.notify("Run config reloaded", vim.log.levels.INFO)
			end)
		)
	end
end

local function load_and_cache_config()
	local filepath = vim.fn.getcwd() .. "/run_configs.json"
	config_filepath = filepath
	cached_config = read_config_file(filepath)

	-- Set up file watcher if config exists
	if cached_config then
		setup_file_watcher(filepath)
	end

	return cached_config
end

function M.get_cached_config()
	-- Load config on first access
	if cached_config == nil then
		load_and_cache_config()
	end
	return cached_config
end

return M
