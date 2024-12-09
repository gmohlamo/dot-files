local wezterm = require 'wezterm'
local config = {}

config.font = wezterm.font 'JetBrains Mono'
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.color_scheme = "Mathias"
config.font_size = 9.5
config.window_padding = {
	left = 3,
	right = 1,
	top = 0,
	bottom = 0,
}
config.enable_scroll_bar = false
config.window_background_opacity = 0.9

return config
