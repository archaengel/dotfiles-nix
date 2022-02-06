local api = vim.api

api.nvim_exec([[
    augroup Packer
        autocmd!
        autocmd BufWritePost plugins.lua PackerCompile
    augroup END]], false)

api.nvim_exec([[
    augroup Linting
        autocmd!
        autocmd BufWritePre *.js Neoformat
        autocmd BufWritePre *.ts* Neoformat
        autocmd BufWritePre *.rs Neoformat
        autocmd BufWritePre *.lua Neoformat
    augroup END]], false)

api.nvim_exec([[
    augroup Indentation
        autocmd!
        autocmd FileType javascript setlocal shiftwidth=2 softtabstop=2 tabstop=2
    augroup END]], false)
