local colors = require'tokyonight.colors'.setup {}
local parser_config = require'nvim-treesitter.parsers'.get_parser_configs()
parser_config.clojure.filetype_to_parsername = 'cljs'

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
