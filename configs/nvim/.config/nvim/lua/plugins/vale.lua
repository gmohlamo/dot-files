return {
	'marcelofern/vale.nvim',
	config = function()
		require("vale").setup({
			bin = "/usr/bin/vale",
			vale_config_path = "$HOME/.config/vale/vale.ini",
		})
	end,
}
