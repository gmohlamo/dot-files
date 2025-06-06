return {
	"neovim/nvim-lspconfig",
	event = {
		"BufReadPre",
		"BufNewFile",
	},
	dependencies = {
		"mason-org/mason-lspconfig.nvim",
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

		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "💣",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.INFO] = "🔍",
					[vim.diagnostic.severity.HINT] = "💡",
				},
				numhl = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.HINT] = "",
					[vim.diagnostic.severity.INFO] = "",
				},
			},
		})

		local virt_lines_ns = vim.api.nvim_create_namespace 'on_diagnostic_jump'
		--- @param diagnostic? vim.Diagnostic
		--- @param bufnr integer
		local function on_jump(diagnostic, bufnr)
			if not diagnostic then return end
			vim.diagnostic.show(
				virt_lines_ns,
				bufnr,
				{ diagnostic },
				{ virtual_lines = { current_line = true }, virtual_text = false }
			)
		end
		vim.diagnostic.config({ jump = { on_jump = on_jump } })

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
			["lua_ls"] = function()
				local on_attach = function(client, bufnr)
					-- Enable completion triggered by <c-x><c-o>
					vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
				end
				lspconfig["lua_ls"].setup({
					on_attach = on_attach,
					settings = {
						Lua = {
							telemetry = {
								enable = false
							},
						},
					},
					on_init = function(client)
						--local join = vim.fs.joinpath
						--local path = client.workspace_folders[1].name

						-- Don't do anything if there is project local config
						--if vim.uv.fs_stat(join(path, '.luarc.json'))
						--    or vim.uv.fs_stat(join(path, '.luarc.jsonc'))
						--then
						--	return
						--end

						local nvim_settings = {
							runtime = {
								-- Tell the language server which version of Lua you're using
								version = 'LuaJIT',
							},
							diagnostics = {
								-- Get the language server to recognize the `vim` global
								globals = { 'vim' }
							},
							workspace = {
								checkThirdParty = false,
								library = {
									-- Make the server aware of Neovim runtime files
									vim.env.VIMRUNTIME,
									vim.fn.stdpath('config'),
								},
							},
						}

						client.config.settings.Lua = vim.tbl_deep_extend(
							'force',
							client.config.settings.Lua,
							nvim_settings
						)
					end,
				})
			end,
		})
	end,
}
