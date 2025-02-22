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
				"pbls",
				"gopls",
				"html",
				"vtsls",
				"textlsp",
				"lua_ls",
				"vimls",
				"texlab", -- 🤷 I found it in the mason-lspconfig LSP list
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
