vim.cmd([[
let g:vimwiki_list = [{'path':"$HOME/Documents/Notes/vim.wiki/", "nested_syntaxes":{"python":"python","c++":"cpp","bash":"bash", "html":"html",
			\ "json":"json", "nmap":"nmap", "ps1":"ps1", "xml":"xml", "markdown":"markdown", "php":"php", "yaml":"yaml"},
			\ 'template_path': '$HOME/Documents/Notes/vim.wiki_html/',
			\ 'template_default': 'default',
			\ 'template_ext': '.tpl'}]

let g:vimwiki_global_ext = 0
call vimwiki#vars#init()
]])
