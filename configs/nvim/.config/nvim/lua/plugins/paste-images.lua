return {
	"gmohlamo/pastify.nvim", --like the package... Just wanted to change how the "absolute" bit worked
	cmd = { 'Pastify', 'PastifyAfter' },
	event = { 'BufReadPost *.wiki' },
	keys = {
		{ noremap = true, mode = "n", '<leader>P', "<cmd>PastifyAfter<CR>" },
	},
	config = function()
		require('pastify').setup({
			opts = {
				local_path = "/imgs/",
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
