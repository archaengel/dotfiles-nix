local nvim_exec = function(txt) vim.api.nvim_exec(txt, false) end
local nnoremap = vim.keymap.nnoremap
local inoremap = vim.keymap.inoremap

local function custom_attach(client)
    local resolved_capabilities = client.resolved_capabilities
    if resolved_capabilities.document_highlight then
        nvim_exec [[
            augroup docuemnt_highlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
        ]]
    end

    nnoremap {'<leader>gd', vim.lsp.buf.definition}
    nnoremap {'K', vim.lsp.buf.hover}
    inoremap {'<C-s>', vim.lsp.buf.signature_help}

    if resolved_capabilities.document_formatting then
        nvim_exec [[
            augroup document_formatting
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
            augroup END
        ]]
    end

    if resolved_capabilities.rename then
        nnoremap {'<leader>rn', vim.lsp.buf.rename}
    end
end

return {custom_attach = custom_attach}
