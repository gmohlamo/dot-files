return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	lazy = false,
	config = function()
		local treesitter = require("nvim-treesitter.configs")

		treesitter.setup({
			highlight = {
				enable = true,
			},
			indent = {
				enable = true,
			},
			auto_install = true,
			sync_install = false,
			ignore_install = {},
			ensure_installed = {
				"python",
				"go",
				"json",
				"javascript",
				"c",
				"bash",
				"dockerfile",
				"lua",
				"vim",
				"yaml",
			},
		})
	end,
}
