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
		local html_capabilities = vim.lsp.protocol.make_client_capabilities()
		html_capabilities.textDocument.completion.completionItem.snippetSupport = true
		-- local util = require 'lspconfig.util'
		vim.lsp.config('html', {
			capabilities = html_capabilities,
			cmd = { "vscode-html-language-server", "--stdio" },
			filetypes = { "html" },
			init_options = {
				configurationSection = { "html", "css", "javascript" },
				embeddedLanguages = {
					css = true,
					javascript = true,
				},
				provideFormatter = true,
			},
			root_markers = { "package.json", ".git" },
			settings = {},
		})
		vim.lsp.config('cssls', {
			capabilities = html_capabilities,
			cmd = { 'vscode-css-language-server', '--stdio' },
			filetypes = { 'css', 'scss', 'less' },
			init_options = {
				configurationSection = { "css" },
				provideFormatter = true,
			}, -- needed to enable formatting capabilities
			single_file_support = true,
			root_markers = { "package.json", ".git" },
			settings = {
				css = { validate = true },
				scss = { validate = true },
				less = { validate = true },
			},
		})
		local base_on_attach = vim.lsp.config.eslint.on_attach
		vim.lsp.config("eslint", {
			on_attach = function(client, bufnr)
				if not base_on_attach then return end

				base_on_attach(client, bufnr)
				vim.api.nvim_create_autocmd("BufWritePre", {
					buffer = bufnr,
					command = "LspEslintFixAll",
				})
			end,
			cmd = { "vscode-eslint-language-server", "--stdio" },
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte", "astro", "htmlangular" },
			handlers = {
				['eslint/openDoc'] = function(_, result)
					if result then
						vim.ui.open(result.url)
					end
					return {}
				end,
				['eslint/confirmESLintExecution'] = function(_, result)
					if not result then
						return
					end
					return 4 -- approved
				end,
				['eslint/probeFailed'] = function()
					vim.notify('[lspconfig] ESLint probe failed.', vim.log.levels.WARN)
					return {}
				end,
				['eslint/noLibrary'] = function()
					vim.notify('[lspconfig] Unable to find ESLint library.', vim.log.levels.WARN)
					return {}
				end,
			},
			settings = {
				codeAction = {
					disableRuleComment = {
						enable = true,
						location = "separateLine"
					},
					showDocumentation = {
						enable = true
					}
				},
				codeActionOnSave = {
					enable = false,
					mode = "all"
				},
				experimental = {},
				format = true,
				nodePath = "",
				onIgnoredFiles = "off",
				problems = {
					shortenToSingleLine = false
				},
				quiet = false,
				rulesCustomizations = {},
				run = "onType",
				useESLintClass = false,
				validate = "on",
				workingDirectory = {
					mode = "auto"
				}
			},
			workspace_required = true,
		})
		vim.diagnostic.config({ jump = { on_jump = on_jump } })
		vim.lsp.config("tinymist", {
			capabilities = capabilities,
			cmd = { "tinymist" },
			filetypes = { "typst" },
			root_markers = { '.git' },
			settings = {
			},
		})
		vim.lsp.config("texlab", {
			capabilities = capabilities,
			settings = {
				texlab = {
					bibtexFormatter = "texlab",
					build = {
						args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f", "-auxdir=build" },
						executable = "latexmk",
						forwardSearchAfter = true,
						onSave = true,
						auxDirectory = "build",
					},
					chktex = {
						onEdit = false,
						onOpenAndSave = false,
					},
					diagnosticsDelay = 300,
					formatterLineLength = 80,
					forwardSearch = {
						executable = "zathura",
						args = { "--synctex-forward", "%l:1:%f", "%p" },
					},
					latexFormatter = "latexindent",
					latexindent = {
						modifyLineBreaks = false,
					},
				}
			},
		})
		vim.lsp.config("clangd", {
			on_attach = function(client, bufnr)
				-- Enable completion triggered by <c-x><c-o>
				_ = client
				vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
			end,
			capabilities = capabilities,
			filetypes = { "c", "cpp" },
			completions = {
				completeFunctionCalls = true,
			},
		})
		vim.lsp.config("gopls", {
			on_attach = function(client, bufnr)
				-- Enable completion triggered by <c-x><c-o>
				_ = client
				vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
			end,
			capabilities = capabilities,
			cmd = { 'gopls' },
			filetypes = { "go", "gomod", "gowork", "gotmpl" },
			completions = {
				completeFunctionCalls = true,
			},

		})
		vim.lsp.config("jedi_language_server", {
			on_attach = function(client, bufnr)
				-- Enable completion triggered by <c-x><c-o>
				_ = client
				vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
			end,
			capabilities = capabilities,
			filetypes = { "python" },
			cmd = { "jedi-language-server" },
			completions = {
				completeFunctionCalls = true,
			},
		})
		vim.lsp.config("vtsls", {
			on_attach = function(client, bufnr)
				-- Enable completion triggered by <c-x><c-o>
				_ = client
				vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
			end,
			init_options = {
				hostInfo = 'neovim',
			},
			filetypes = {
				'javascript',
				'javascriptreact',
				'typescript',
				'typescriptreact',
			},
			root_dir = function(bufnr, on_dir)
				-- The project root is where the LSP can be started from
				-- As stated in the documentation above, this LSP supports monorepos and simple projects.
				-- We select then from the project root, which is identified by the presence of a package
				-- manager lock file.
				local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb',
					'bun.lock' }
				-- Give the root markers equal priority by wrapping them in a table
				root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers, { '.git' } }
				    or vim.list_extend(root_markers, { '.git' })
				-- exclude deno
				local deno_root = vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' })
				local deno_lock_root = vim.fs.root(bufnr, { 'deno.lock' })
				local project_root = vim.fs.root(bufnr, root_markers)
				if deno_lock_root and (not project_root or #deno_lock_root > #project_root) then
					-- deno lock is closer than package manager lock, abort
					return
				end
				if deno_root and (not project_root or #deno_root >= #project_root) then
					-- deno config is closer than or equal to package manager lock, abort
					return
				end
				-- project is standard TS, not deno
				-- We fallback to the current working directory if no project root is found
				on_dir(project_root or vim.fn.getcwd())
			end,
			capabilities = capabilities,
			cmd = { "vtsls", "--stdio" },
			completions = {
				completeFunctionCalls = true,
			},
			single_file_support = true,
		})
		local nvim_lsp = require 'lspconfig'
		vim.lsp.config("pbls", {
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				-- Enable completion triggered by <c-x><c-o>
				_ = client
				vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
			end,
			cmd = { "pbls" },
			filetypes = { "proto" },
			root_dir = nvim_lsp.util.root_pattern(".pbls.toml", ".git"),
		})
		vim.lsp.config("autotools_ls", {
			--capabilities = capabilities, Not sure if this is used for this
			on_attach = function(client, bufnr)
				-- Enable completion triggered by <c-x><c-o>
				_ = client
				vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
			end,
			filetypes = { 'config', 'automake', 'make' },
			root_dir = function(bufnr, on_dir)
				local util = require 'lspconfig.util'
				local fname = vim.api.nvim_buf_get_name(bufnr)
				on_dir(util.root_pattern(unpack({ 'configure.ac', 'Makefile', 'Makefile.am', '*.mk' }))(
					fname))
			end,
			cmd = { "autotools-language-server" },
		})
		vim.lsp.config("arduino_language_server", {
			filetypes = { 'arduino' },
			root_dir = function(bufnr, on_dir)
				local util = require 'lspconfig.util'
				local fname = vim.api.nvim_buf_get_name(bufnr)
				on_dir(util.root_pattern('*.ino')(fname))
			end,
			cmd = {
				'arduino-language-server',
			},
			capabilities = {
				textDocument = {
					---@diagnostic disable-next-line: assign-type-mismatch
					semanticTokens = vim.NIL,
				},
				workspace = {
					---@diagnostic disable-next-line: assign-type-mismatch
					semanticTokens = vim.NIL,
				},
			},
		})
		--variables for lua_ls
		local luals_root_markers1 = {
			'.emmyrc.json',
			'.luarc.json',
			'.luarc.jsonc',
		}
		local luals_root_markers2 = {
			'.luacheckrc',
			'.stylua.toml',
			'stylua.toml',
			'selene.toml',
			'selene.yml',
		}
		vim.lsp.config("lua_ls", {
			on_attach = function(client, bufnr)
				-- Enable completion triggered by <c-x><c-o>
				_ = client
				vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
			end,
			settings = {
				Lua = {
					telemetry = {
						enable = false
					},
					codeLens = { enable = true },
					hint = { enable = true, semicolon = 'Disable' },
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
			cmd = { 'lua-language-server' },
			filetypes = { 'lua' },
			root_markers = vim.fn.has('nvim-0.11.3') == 1 and
			    { luals_root_markers1, luals_root_markers2, { '.git' } }
			    or vim.list_extend(vim.list_extend(luals_root_markers1, luals_root_markers2), { '.git' }),
			---@type lspconfig.settings.lua_ls
		})
		mason_lspconfig.setup({})
	end,
}
