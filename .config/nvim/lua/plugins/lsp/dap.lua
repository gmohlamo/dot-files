return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"leoluz/nvim-dap-go",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- debugger UI elements
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.open()
		end
		dapui.setup()
		-- setup debugger keymaps
		vim.keymap.set('n', '<F5>', dap.continue, {})
		vim.keymap.set('n', '<F10>', dap.step_over, {})
		vim.keymap.set('n', '<F11>', dap.step_into, {})
		vim.keymap.set('n', '<F12>', dap.step_out, {})
		vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, {})
		vim.keymap.set('n', '<Leader>db', dap.set_breakpoint, {})
		vim.keymap.set('n', '<Leader>dc', dap.continue, {})
		vim.keymap.set('n', '<Leader>dx', dap.close, {})
		vim.keymap.set('n', '<Leader>lp',
			function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
		vim.keymap.set('n', '<Leader>dr', dap.repl.open, {})
		vim.keymap.set('n', '<Leader>dl', dap.run_last, {})
		vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
			require('dap.ui.widgets').hover()
		end)
		vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
			require('dap.ui.widgets').preview()
		end)
		vim.keymap.set('n', '<Leader>df', function()
			local widgets = require('dap.ui.widgets')
			widgets.centered_float(widgets.frames)
		end)
		vim.keymap.set('n', '<Leader>ds', function()
			local widgets = require('dap.ui.widgets')
			widgets.centered_float(widgets.scopes)
		end)
		-- dap symbols
		vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
		vim.fn.sign_define('DapStopped', { text = '🍺', texthl = '', linehl = '', numhl = '' })
		--vim.fn.sign_define("DapBreakpointRejected", { text = "🙈", texthl = "DiagnosticError" })
		--vim.fn.sign_define("DapBreakpointCondition", { text = "🧐", texthl = "DiagnosticInfo" })
		--vim.fn.sign_define("DapLogPoint", { text = "📓", texthl = "DiagnosticInfo" })
		-- setup golang debugger
		require("dap-go").setup({
			dap_configurations = {
				{
					type = "go",
					name = "Attach remote",
					mode = "remote",
					request = "attach",
				},
			},
			delve = {
				path = "dlv",
				initialize_timeout_sec = 20,
				port = "${port}",
				args = {},
				build_flags = {},
				cwd = nil,
			},
			tests = {
				verbose = false,
			},
		})
	end,
}
