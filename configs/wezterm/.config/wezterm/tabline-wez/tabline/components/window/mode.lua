local M = {}

function M.update(window)
	local mode = M.get(window):gsub('_mode', '')
	mode = mode:upper()
	if window:leader_is_active() then
		mode = mode .. " " .. utf8.char(0x1f608)
	end
	return mode
end

function M.get(window)
	local key_table = window:active_key_table()

	if key_table == nil or not key_table:find('_mode$') then
		key_table = 'normal_mode'
	end

	return key_table
end

return M
