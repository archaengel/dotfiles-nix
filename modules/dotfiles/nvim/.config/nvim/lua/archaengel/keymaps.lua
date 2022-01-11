local g = vim.g
local nnoremap = vim.keymap.nnoremap
local tnoremap = vim.keymap.tnoremap
local telescope_builtin = require 'telescope.builtin'

g.mapleader = ' '

nnoremap {'<leader>pv', ':Ex<CR>'}

-- terminal
tnoremap {'<Esc><Esc>', [[<C-\><C-n>]]}

-- telescope
nnoremap {
    '<leader>ff', function() telescope_builtin.find_files {hidden = true} end
}
nnoremap {'<leader>bf', require'archaengel.telescope.custom_pickers'.buffers}
nnoremap {'<leader>fb', telescope_builtin.file_browser}
nnoremap {'<leader>lg', telescope_builtin.live_grep}
nnoremap {
    '<leader>en',
    function() telescope_builtin.find_files {cwd = "~/.config/nvim"} end
}

-- lsp
nnoremap {
    '<leader>vsd',
    function()
        vim.lsp.diagnostic.show_line_diagnostics()
        vim.lsp.diagnostic.show_line_diagnostics()
    end,
    silent = true
}

-- netrw
nnoremap {'<C-b>', function() vim.cmd [[:Lexplore<CR>]] end}

-- rest.nvim
nnoremap {'<leader>rq', require'rest-nvim'.run}
