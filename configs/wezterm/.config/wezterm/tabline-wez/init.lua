local wezterm = require('wezterm')

local M = {}

--- Checks if the user is on windows
local is_windows = string.match(wezterm.target_triple, 'windows') ~= nil
local separator = is_windows and '\\' or '/'

--local plugin_dir = wezterm.plugin.list()[1].plugin_dir:gsub(separator .. '[^' .. separator .. ']*$', '')
local plugin_dir = ""


--- Checks if the plugin directory exists
local function directory_exists(path)
	local success, result = pcall(wezterm.read_dir, plugin_dir .. path)
	return success and result
end

--- Returns the name of the package, used when requiring modules
local function get_require_path()
	local path1 = ''
	local path2 = ''
	return directory_exists(path2) and path2 or path1
end

package.path = package.path
    .. ';'
    .. plugin_dir
    .. separator
    .. get_require_path()
    .. separator
    .. 'plugin'
    .. separator
    .. '?.lua'

function M.setup(opts)
	require('tabline-wez.tabline.config').set(opts)

	wezterm.on('update-status', function(window)
		require('tabline-wez.tabline.component').set_status(window)
	end)

	wezterm.on('format-tab-title', function(tab, _, _, _, hover, _)
		return require('tabline-wez.tabline.tabs').set_title(tab, hover)
	end)

	require('tabline-wez.tabline.extension').load()
end

function M.apply_to_config(config)
	config.use_fancy_tab_bar = false
	config.show_new_tab_button_in_tab_bar = false
	config.tab_max_width = 64
	config.window_decorations = 'RESIZE'
	config.window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	}
	config.colors = {
		tab_bar = {
			background = require('tabline-wez.tabline.config').colors.normal_mode.c.bg,
		},
	}
	config.status_update_interval = 500
end

function M.get_config()
	return require('tabline-wez.tabline.config').opts
end

function M.get_colors()
	return require('tabline-wez.tabline.config').colors
end

function M.refresh(window, tab)
	if window then
		require('tabline-wez.tabline.component').set_status(window)
	end
	if tab then
		require('tabline-wez.tabline.tabs').set_title(tab)
	end
end

return M
