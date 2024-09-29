return {
	"lervag/vimtex",
	lazy = false,
	-- the whole purpose of this plugin is to provide a means with which you can compile
	-- and automatically call zahura to view your latex files
	init = function()
		vim.g.vimtex_view_method = "zathura"
	end,
}
