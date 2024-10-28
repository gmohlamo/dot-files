return {
	"TobinPalmer/pastify.nvim",
	cmd = { 'Pastify', 'PastifyAfter' },
	event = { 'BufReadPost' },
	keys = {
		{ noremap = true, mode = "n", '<leader>P', "<cmd>Pastify<CR>" },
	},
	config = function()
		require('pastify').setup({
			opts = {
				absolute_path = true,
				local_path = "/assets/",
				save = "local",
				filename = '',
				default_ft = 'markdown',
			},
			ft = {
				markdown = '![]($IMG$)',
				vimwiki = '{{file:$IMG$}}',
			},
		})
	end,
}
