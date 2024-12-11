local wezterm = require 'wezterm'
local config = {}

config.font = wezterm.font 'JetBrains Mono'
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_and_split_indices_are_zero_based = true
config.use_fancy_tab_bar = false
config.color_scheme = "Gnometerm (terminal.sexy)"
config.audible_bell = "Disabled"
config.font_size = 9.5
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.enable_scroll_bar = false
config.window_background_opacity = 0.9

-- disable default keybinds
config.disable_default_key_bindings = true
--keys
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = require("keybinds")

-- key_tables
config.key_tables = require("key_tables")

--tab
local tabline = require("tabline")
tabline.apply_to_config(config)

return config
