local g = vim.g

-- Telescope
require('telescope').setup {}
require('telescope').load_extension('fzy_native')

-- Neoformat
g.neoformat_enabled_javascript = {'prettier'}
g.neoformat_javascript_prettier = {
    exe = './node_modules/.bin/prettier',
    args = {'--stdin', '--stdin-filepath', '"%:p"'},
    stdin = 1
}

g.neoformat_enabled_typescriptreact = {'eslint_d'}
g.neoformat_typescript_prettier = {
    exe = './node_modules/.bin/prettier',
    args = {'--stdin', '--stdin-filepath', '"%:p"'},
    stdin = 1
}
g.neoformat_typescriptreact_eslint_d = {
    args = {'--ext', '.tsx', '--stdin', '--stdin-filename', '"%:p"'},
    stdin = 1
}
-- g.neoformat_typescriptreact_prettier = {
--     exe = './node_modules/.bin/prettier',
--     args = {'--stdin', '--stdin-filepath', '"%:p"'},
--     stdin = 1
-- }
-- g.neoformat_typescriptreact_tslint = {
--     exe = './node_modules/.bin/tslint',
--     args = {'--stdin', '--stdin-filepath', '"%:p"'},
--     stdin = 1
-- }
g.neoformat_enabled_lua = {'luaformat'}

-- Compe
require'compe'.setup {
    enabled = true,
    autocomplete = true,
    debug = false,
    min_length = 1,
    preselect = 'enable',
    throttle_time = 80,
    source_timeout = 200,
    resolve_timeout = 800,
    incomplete_delay = 400,
    max_abbr_width = 100,
    max_kind_width = 100,
    max_menu_width = 100,
    documentation = true,

    source = {
        path = true,
        buffer = true,
        calc = true,
        nvim_lsp = true,
        nvim_lua = true,
        vsnip = true,
        ultisnips = true
    }
}

