local g = vim.g

g.neoformat_enabled_javascript = {'prettier'}
g.neoformat_javascript_prettier = {
    exe = './node_modules/.bin/prettier',
    args = {'--stdin', '--stdin-filepath', '"%:p"'},
    stdin = 1
}

g.neoformat_enabled_typescriptreact = {'eslint_d'}
g.neoformat_typescriptreact_eslint_d = {
    exe = './node_modules/.bin/eslint_d',
    args = {'"%:p"'}
}
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

