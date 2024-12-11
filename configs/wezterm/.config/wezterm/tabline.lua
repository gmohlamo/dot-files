local wezterm = require 'wezterm'
local tabline = require 'tabline-wez'



tabline.setup({
	options = {
		icons_enabled = true,
		theme = 'darkermatrix',
		color_overrides = {},
		section_separators = {
			left = wezterm.nerdfonts.ple_right_half_circle_thick,
			right = wezterm.nerdfonts.ple_left_half_circle_thick,
		},
		component_separators = {
			left = wezterm.nerdfonts.ple_right_half_cirle_thin,
			right = wezterm.nerdfonts.ple_left_half_circle_thin,
		},
		tab_separators = {
			left = wezterm.nerdfonts.ple_right_half_circle_thick,
			right = wezterm.nerdfonts.ple_left_half_circle_thick,
		},
	},
	sections = {
		tabline_a = { 'mode', padding = { left = 1, right = 1 } },
		tabline_b = { 'workspace' },
		tabline_c = { ' ' },
		tab_active = {
			'process',
			{ 'parent', padding = 0 },
			'/',
			{ 'cwd',    padding = { left = 0, right = 1 } },
			{ 'zoomed', padding = 0 },
		},
		tab_inactive = { 'index', { 'process', padding = { left = 0, right = 1 } } },
		tabline_x = { 'ram', 'cpu' },
		tabline_y = { 'datetime' },
		tabline_z = { 'hostname' },
	},
	extensions = {},
})

return tabline
