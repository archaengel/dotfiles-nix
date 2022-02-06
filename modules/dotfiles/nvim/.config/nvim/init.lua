pcall(require, 'impatient')

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
