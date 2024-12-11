local wezterm = require 'wezterm'
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")


tabline.setup({
	options = {
		icons_enabled = true,
		theme = 'Gotham (terminal.sexy)',
		color_overrides = {},
		section_separators = {
			right = wezterm.nerdfonts.ple_left_half_circle_thick,
			left = wezterm.nerdfonts.ple_right_half_cirle_thick,
		},
		component_separators = {
			right = wezterm.nerdfonts.ple_left_half_circle_thin,
			left = wezterm.nerdfonts.ple_right_half_cirle_thin,
		},
		tab_separators = {
			right = wezterm.nerdfonts.ple_left_half_circle_thick,
			left = wezterm.nerdfonts.ple_right_half_circle_thick,
		},
	},
	sections = {
		tabline_a = { 'mode' },
		tabline_b = { 'workspace' },
		tabline_c = { ' ' },
		tab_active = {
			'process',
			--{ 'parent', padding = 0 },
			--'/',
			{ 'cwd',    padding = { left = 0, right = 1 } },
			{ 'zoomed', padding = 0 },
		},
		tab_inactive = { 'index', { 'process', padding = { left = 0, right = 1 } } },
		tabline_x = { 'ram', 'cpu' },
		tabline_y = { 'datetime', 'battery' },
		tabline_z = { 'hostname' },
	},
	extensions = {},
})

return tabline
