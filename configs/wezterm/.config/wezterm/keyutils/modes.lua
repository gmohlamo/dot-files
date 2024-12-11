local wezterm = require 'wezterm'
local value = wezterm.on('update-status', function(window, pane)
	local name = window:active_key_table()
	if name then
		name = 'TABLE: ' .. name
	end
	--return (name or '')
	return "test"
end)

return value
