local custom_attach = require('archaengel.lsp.util').custom_attach
local home = os.getenv('HOME')
local kls_root_path = home .. '/third-party/kotlin-language-server'
local kls_bin_path = kls_root_path ..
                         '/server/build/install/server/bin/kotlin-language-server'

local settings = {kotlin = {compiler = {jvm = {target = "1.8"}}}}

require('lspconfig').kotlin_language_server.setup {
    -- Language server is currently broken when running with java 16
    cmd_env = {JAVA_HOME = os.getenv('JAVA_15')},
    cmd = {kls_bin_path},
    on_attach = custom_attach,
    settings = settings
}
