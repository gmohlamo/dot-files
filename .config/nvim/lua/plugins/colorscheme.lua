return {
	--"folke/tokyonight.nvim",
	"0xstepit/flow.nvim",
	lazy = false,
	priority = 1000,
	opts = {},
	config = function()
		require("flow").setup({
			dark_theme = true,
			high_contrast = true,
			transparent = false,
			fluo_color = "orange",
			mode = "dark",
			aggressive_spell = true,
		})
		vim.cmd [[colorscheme flow]]
	end
} -- this should make it easier to handle colorscheme through external providers
