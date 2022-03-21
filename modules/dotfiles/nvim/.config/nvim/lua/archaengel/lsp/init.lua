local lsputil = require 'archaengel.lsp.util'
local custom_attach = lsputil.custom_attach
local capabilities = lsputil.capabilities
local lspconfig = require 'lspconfig'

capabilities = require'cmp_nvim_lsp'.update_capabilities(capabilities)
lspconfig.ccls.setup {on_attach = custom_attach, capabilities = capabilities}
lspconfig.hls.setup {on_attach = custom_attach, capabilities = capabilities}
lspconfig.tsserver.setup {
    on_attach = custom_attach,
    capabilities = capabilities
}
-- lspconfig.rls.setup {on_attach = custom_attach}
lspconfig.terraformls.setup {
    on_attach = custom_attach,
    capabilities = capabilities
}
lspconfig.jedi_language_server.setup {
    on_attach = custom_attach,
    capabilities = capabilities
}
lspconfig.rust_analyzer.setup {
    on_attach = custom_attach,
    capabilities = capabilities
}
lspconfig.clojure_lsp.setup {
    on_attach = custom_attach,
    capabilities = capabilities
}
require('archaengel.lsp.luaconfig')
require('archaengel.lsp.kotlin')
