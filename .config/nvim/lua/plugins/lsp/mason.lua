return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"neovim/nvim-lspconfig",
	},
	config = function()
		local mason_tool_installer = require("mason-tool-installer")
		require("mason").setup({
			ui = {
				icons = {
					package_installed = "👍",
					package_pending = "✋",
					package_uninstalled = "👎",
				},
			},
		})
		require("mason-lspconfig").setup({
			automatic_installation = true,
			ensure_installed = {
				"jedi_language_server",
				"clangd",
				"gopls",
				"html",
				"eslint",
				"textlsp",
				"lua_ls",
				"vale_ls",
				"vimls",
				"autotools_ls",
			},
		})
		mason_tool_installer.setup({
			ensure_installed = {
				"prettier",
				"pylint",
			},
		})
	end,
}
