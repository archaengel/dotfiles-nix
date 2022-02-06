local custom_attach = require'archaengel.lsp.util'.custom_attach
local colors = require'tokyonight.colors'.setup {}
-- tree sitter config
require'nvim-treesitter.configs'.setup {
    rainbow = {
        enable = true,
        disable = {'bash'},
        colors = {
            colors.red, colors.orange, colors.yellow, colors.green, colors.blue,
            colors.purple, colors.magenta
        }
    },
    highlight = {enable = true}
}
local parser_config = require'nvim-treesitter.parsers'.get_parser_configs()
parser_config.clojure.used_by = 'cljs'

-- language server config
local lspconfig = require 'lspconfig'
lspconfig.ccls.setup {}
lspconfig.hls.setup {on_attach = custom_attach}
lspconfig.tsserver.setup {on_attach = custom_attach}
-- lspconfig.rls.setup {on_attach = custom_attach}
lspconfig.terraformls.setup {on_attach = custom_attach}
lspconfig.jedi_language_server.setup {on_attach = custom_attach}
lspconfig.rust_analyzer.setup {on_attach = custom_attach}
lspconfig.clojure_lsp.setup {on_attach = custom_attach}
require('archaengel.lsp.luaconfig')
require('archaengel.lsp.kotlin')
