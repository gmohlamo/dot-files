local act = require 'wezterm'.action

local function copy_to()
	return act.Multiple({
		act.CopyTo('Clipboard'),
		act.ClearSelection,
		-- clear the selection mode, but remain in copy mode
		act.CopyMode('ClearSelectionMode'),
	})
end

local key_maps = {
	-- Defines the keys that are active in our resize-pane mode.
	-- Since we're likely to want to make multiple adjustments,
	-- we made the activation one_shot=false. We therefore need
	-- to define a key assignment for getting out of this mode.
	-- 'resize_pane' here corresponds to the name="resize_pane" in
	-- the key assignments above.
	resize_pane = {
		{ key = 'LeftArrow',  action = act.AdjustPaneSize { 'Left', 1 } },
		{ key = 'h',          action = act.AdjustPaneSize { 'Left', 1 } },

		{ key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 1 } },
		{ key = 'l',          action = act.AdjustPaneSize { 'Right', 1 } },

		{ key = 'UpArrow',    action = act.AdjustPaneSize { 'Up', 1 } },
		{ key = 'k',          action = act.AdjustPaneSize { 'Up', 1 } },

		{ key = 'DownArrow',  action = act.AdjustPaneSize { 'Down', 1 } },
		{ key = 'j',          action = act.AdjustPaneSize { 'Down', 1 } },

		-- Cancel the mode by pressing escape
		{ key = 'Escape',     action = 'PopKeyTable' },
	},

	-- Defines the keys that are active in our activate-pane mode.
	-- 'activate_pane' here corresponds to the name="activate_pane" in
	-- the key assignments above.
	activate_pane = {
		{ key = 'LeftArrow',  action = act.ActivatePaneDirection 'Left' },
		{ key = 'h',          action = act.ActivatePaneDirection 'Left' },

		{ key = 'RightArrow', action = act.ActivatePaneDirection 'Right' },
		{ key = 'l',          action = act.ActivatePaneDirection 'Right' },

		{ key = 'UpArrow',    action = act.ActivatePaneDirection 'Up' },
		{ key = 'k',          action = act.ActivatePaneDirection 'Up' },

		{ key = 'DownArrow',  action = act.ActivatePaneDirection 'Down' },
		{ key = 'j',          action = act.ActivatePaneDirection 'Down' },
	},
	copy_mode = {
		{
			key = "v",
			mods = "NONE",
			action = act.CopyMode { SetSelectionMode = 'Cell' }
		},
		{
			key = 'V',
			mods = 'SHIFT',
			action = act.CopyMode { SetSelectionMode = 'Line' },
		},
		{
			key = 'v',
			mods = 'CTRL',
			action = act.CopyMode { SetSelectionMode = 'Block' },
		},
		{
			key = 'y',
			mods = 'NONE',
			action = copy_to(),
		},
		{
			key = 'q',
			mods = 'NONE',
			action = act.Multiple {
				{ CopyMode = 'Close' }
			}
		},
		{ key = 'LeftArrow',  mods = 'NONE', action = act.CopyMode 'MoveLeft' },
		{ key = 'h',          mods = 'NONE', action = act.CopyMode 'MoveLeft' },
		{ key = 'RightArrow', mods = 'NONE', action = act.CopyMode 'MoveRight' },
		{ key = 'l',          mods = 'NONE', action = act.CopyMode 'MoveRight' },
		{ key = 'UpArrow',    mods = 'NONE', action = act.CopyMode 'MoveUp' },
		{ key = 'k',          mods = 'NONE', action = act.CopyMode 'MoveUp' },
		{ key = 'DownArrow',  mods = 'NONE', action = act.CopyMode 'MoveDown' },
		{ key = 'j',          mods = 'NONE', action = act.CopyMode 'MoveDown' },
		-- word navigation
		{ key = 'w',          mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
		{ key = 'b',          mods = 'NONE', action = act.CopyMode 'MoveBackwardWord' },
		-- Big moves
		{ key = 'G',          mods = 'NONE', action = act.CopyMode 'MoveToScrollbackBottom' },
		{ key = 'g',          mods = 'NONE', action = act.CopyMode 'MoveToScrollbackTop' },
	},
	search_mode = {
		{
			key = 'y',
			mods = 'CTRL',
			action = act.ActivateCopyMode,
		},
		{ key = "Escape", mods = "NONE", action = act.CopyMode "Close" },
		{ key = "n",      mods = "CTRL", action = act.CopyMode "NextMatch" },
		{ key = "N",      mods = "CTRL", action = act.CopyMode "PriorMatch" },
	},
}

return key_maps
