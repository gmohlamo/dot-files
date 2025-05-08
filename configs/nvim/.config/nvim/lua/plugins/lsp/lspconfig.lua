return {
	"neovim/nvim-lspconfig",
	event = {
		"BufReadPre",
		"BufNewFile",
	},
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim",                   opts = {} },
	},
	config = function()
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local keymap = vim.keymap -- for conciseness

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }
				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references
				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration
				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions
				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations
				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions
				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection
				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename
				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file
				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line
				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer
				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer
				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts)    -- show documentation for what is under cursor
				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end,
		})

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		local signs = { Error = "💣", Warn = " ", Hint = "💡", Info = "🔍" }
		for type, icon in pairs(signs) do
			local h1 = "DiagnosticSign" .. type
			vim.fn.sign_define(h1, { text = icon, texth1 = h1, numh1 = "" })
		end

		mason_lspconfig.setup({
			-- default handler for installed servers
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,
			["clangd"] = function()
				local on_attach = function(client, bufnr)
					-- Enable completion triggered by <c-x><c-o>
					vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
				end
				-- configure clangd
				-- local nvim_lsp = require 'nvim_lsp'
				lspconfig["clangd"].setup({
					capabilities = capabilities,
					filetypes = { "c", "cpp" },
					completions = {
						completeFunctionCalls = true,
					},
					on_attach = on_attach,
				})
			end,
			["gopls"] = function()
				local on_attach = function(client, bufnr)
					-- Enable completion triggered by <c-x><c-o>
					vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
				end
				lspconfig["gopls"].setup({
					capabilities = capabilities,
					cmd = { 'gopls' },
					filetypes = { "go", "gomod", "gowork", "gotmpl" },
					completions = {
						completeFunctionCalls = true,
					},
					on_attach = on_attach,
				})
			end,
			["jedi_language_server"] = function()
				local on_attach = function(client, bufnr)
					-- Enable completion triggered by <c-x><c-o>
					vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
				end
				lspconfig["jedi_language_server"].setup({
					capabilities = capabilities,
					filetypes = { "python" },
					cmd = { "jedi-language-server" },
					completions = {
						completeFunctionCalls = true,
					},
					on_attach = on_attach,
				})
			end,
			["vtsls"] = function()
				local on_attach = function(client, bufnr)
					-- Enable completion triggered by <c-x><c-o>
					vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
				end
				lspconfig["vtsls"].setup({
					cmd = { "vtsls", "--stdio" },
					filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
					completions = {
						completeFunctionCalls = true,
					},
					single_file_support = true,
					on_attach = on_attach,
				})
			end,
			["texlab"] = function()
				lspconfig["texlab"].setup({
					capabilities = capabilities,
					filetypes = { "tex", "plaintex", "bib" },
					settings = {
						auxDirectory = ".",
						bibtexFormatter = "texlab",
						build = {
							args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
							executable = "latexmk",
							forwardSearchAfter = false,
							onSave = false,
						},
						chktex = {
							onEdit = false,
							onOpenAndSave = false,
						},
						diagnosticsDelay = 300,
						formatterLineLength = 80,
						forwardSearch = {
							args = {},
						},
						latexFormatter = "latexindent",
						latexindent = {
							modifyLineBreaks = false,
						},
					},
					single_file_support = true,
				})
			end,
			-- ideally this should give us intellisense in latex projects...
			-- I might need to keep testing though
			["textlsp"] = function()
				lspconfig["textlsp"].setup({
					capabilities = capabilities,
					filetypes = { "tex" },
					cmd = { "textlsp" },
					settings = {
						textLSP = {
							analysers = {
								languagetool = {
									check_text = {
										on_change = false,
										on_open = true,
										on_save = true,
									},
									enabled = true,
								},
							},
							documents = {
								org = {
									org_todo_keywords = { "TODO", "IN_PROGRESS", "DONE" },
								},
							},
						},
					},
					single_file_support = true,
				})
			end,
			["pbls"] = function()
				local on_attach = function(client, bufnr)
					-- Enable completion triggered by <c-x><c-o>
					vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
				end
				local nvim_lsp = require 'lspconfig'
				lspconfig["pbls"].setup({
					capabilities = capabilities,
					on_attach = on_attach,
					cmd = { "pbls" },
					filetypes = { "proto" },
					root_dir = nvim_lsp.util.root_pattern(".pbls.toml", ".git"),
				})
			end,
			["autotools_ls"] = function()
				lspconfig["autotools_ls"].setup({
					capabilities = capabilities,
					filetypes = {
						"make",
						"automake",
						"config",
					},
					cmd = { "autotools-language-server" },
				})
			end,
		})
	end,
}
