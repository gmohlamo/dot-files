local wezterm = require("wezterm")
local keys = {
	{
		mods = "LEADER",
		key = "c",
		action = wezterm.action.SpawnTab "CurrentPaneDomain",
	},
	{
		mods = "LEADER",
		key = "x",
		action = wezterm.action.CloseCurrentPane { confirm = true },
	},
	{
		mods = "LEADER",
		key = "[",
		action = wezterm.action.ActivateTabRelative(-1)
	},
	{
		mods = "LEADER",
		key = "]",
		action = wezterm.action.ActivateTabRelative(1)
	},
	{
		mods = "LEADER|SHIFT",
		key = "%",
		action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" },
	},
	{
		mods = "LEADER",
		key = "'",
		action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" },
	},
	{
		mods = "CTRL|SHIFT",
		key = "V",
		action = wezterm.action.PasteFrom 'Clipboard'
	},
	{
		mods = "CTRL|SHIFT",
		key = "C",
		action = wezterm.action.CopyTo 'ClipboardAndPrimarySelection',
	},
	{
		mods = "LEADER",
		key = "w",
		action = wezterm.action.CloseCurrentTab { confirm = true }
	},
	{
		key = 'r',
		mods = 'LEADER',
		action = wezterm.action.ActivateKeyTable {
			name = 'resize_pane',
			one_shot = false,
		},
	},
	{
		key = 'a',
		mods = 'LEADER',
		action = wezterm.action.ActivateKeyTable {
			name = 'activate_pane',
			timeout_milliseconds = 1000,
		},
	},
	{
		key = "X",
		mods = "LEADER|SHIFT",
		action = wezterm.action.ActivateCopyMode
	},
	{
		key = "s",
		mods = "LEADER",
		action = wezterm.action.Search "CurrentSelectionOrEmptyString"
	},
}

for i = 0, 8 do
	-- leader + number to activate that tab
	table.insert(keys,
		{
			key = tostring(i + 1),
			mods = "LEADER",
			action = wezterm.action.ActivateTab(i),
		}
	)
end

table.insert(keys,
	{
		key = tostring(0),
		mods = "LEADER",
		action = wezterm.action.ActivateTab(9),
	}
)

return keys