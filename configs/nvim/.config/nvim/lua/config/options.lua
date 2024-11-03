-- Standard line numbering config
vim.opt.number = true
vim.opt.syntax = "on"
vim.opt.relativenumber = true
-- enable mouse interaction
vim.opt.mouse = "a"
vim.opt.termguicolors = true
-- Setup colour scheme
-- this colour scheme is dependent on a plugin
-- vim.cmd[[colorscheme tokyonight-moon]]
-- vim.cmd[[colorscheme moonfly]]
vim.opt.background = "dark"

-- Improve search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Tree
vim.g.netrw_liststyle = 3

-- Clipboard in the default register (this beats register "+" by a mile for me)
vim.opt.clipboard:append("unnamedplus")


