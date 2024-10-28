return {
	"TobinPalmer/pastify.nvim",
	config = function()
		require('pastify').setup({
			opts = {
				absolute_path = true,
				local_path = os.getenv("HOME") .. "/Documents/Notes/vim.wiki/assets/",
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
