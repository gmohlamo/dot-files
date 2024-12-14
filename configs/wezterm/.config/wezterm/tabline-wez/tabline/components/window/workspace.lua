local wezterm = require('wezterm')

return {
	default_opts = {
		icon = utf8.char(0x1f977)
	},
	update = function()
		local workspace = wezterm.mux.get_active_workspace()
		workspace = string.match(workspace, '[^/\\]+$')
		return workspace
	end,
}
