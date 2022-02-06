local nvim_exec = function(txt) vim.api.nvim_exec(txt, false) end

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

    vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover)
    vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help)
    vim.keymap.set('n', '<leader>pe', vim.lsp.diagnostic.goto_prev)
    vim.keymap.set('n', '<leader>ne', vim.lsp.diagnostic.goto_next)

    if resolved_capabilities.document_formatting then
        nvim_exec [[
            augroup document_formatting
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
            augroup END
        ]]
    end

    if resolved_capabilities.rename then
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
    end
end

return {custom_attach = custom_attach}
