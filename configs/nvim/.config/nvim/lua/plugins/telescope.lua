return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-telescope/telescope-live-grep-args.nvim",
	},
	config = function()
		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
		vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
		vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
		vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
		vim.keymap.set('n', '<leader>fs', require('telescope').extensions.live_grep_args.live_grep_args,
			{ noremap = true, desc = 'Telescope live_grep_args in notes' })
		require('telescope').setup({
			extensions = {
				live_grep_args = {
					search_dirs = { "~/Documents/Notes/vim.wiki/" },
				},
			},
		})
		require('telescope').load_extension('live_grep_args')
	end,
}
