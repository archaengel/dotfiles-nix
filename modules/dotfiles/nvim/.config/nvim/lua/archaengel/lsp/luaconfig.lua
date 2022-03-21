local lsputil = require 'archaengel.lsp.util'
local custom_attach = lsputil.custom_attach
local capabilities = lsputil.capabilities

local system_name
if vim.fn.has("mac") == 1 then
    system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
    system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
    system_name = "Windows"
else
    print("Unsupported system for sumneko")
end

local libt = {}
local function add(lib)
    for _, p in ipairs(vim.fn.expand(lib, false, true)) do
        local res_p = vim.loop.fs_realpath(p)
        if res_p then libt[res_p] = true end
    end
end

local home = os.getenv('HOME')
local sumneko_root_path = home .. '/third-party/lua-language-server'
local sumneko_binary = sumneko_root_path .. '/bin/' .. system_name ..
                           '/lua-language-server'

-- Configure runtime path
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

-- Configure library
add('$VIMRUNTIME/lua')
add('$VIMRUNTIME/lua/vim/lsp')
add('~/.config/nvim')
add('~/.local/share/nvim/site/pack/packer/opt/*')
add('~/.local/share/nvim/site/pack/packer/start/*')
require('lspconfig').sumneko_lua.setup {
    cmd = {sumneko_binary, '-E', sumneko_root_path .. '/main.lua'},
    capabilities = capabilities,
    on_attach = custom_attach,
    settings = {
        Lua = {
            runtime = {
                -- LuaJIT in the case of Neovim
                version = 'LuaJIT',
                -- Setup your lua path
                path = runtime_path
            },
            diagnostics = {
                -- Get the language server to recognize globals
                globals = {'vim', 'P', 'R', 'RELOAD'}
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = libt,
                maxPreload = 10000,
                preloadFileSize = 10000
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {enable = false}
        }
    }
}
