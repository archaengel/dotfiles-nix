pcall(require, 'impatient')

-- Run astronauta before anything else (but after impatient)
vim.cmd [[runtime plugin/astronauta.vim]]

require('archaengel.options')
require('archaengel.plugins')
require('archaengel.plugins.config')
require('archaengel.globals')
require('archaengel.netrw')
require('archaengel.augroups')
require('archaengel.statusline')

-- Setup treesitter and language server
require('archaengel.lsp')
require('archaengel.keymaps')
