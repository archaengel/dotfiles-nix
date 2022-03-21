return require('packer').startup {
    function(use)
        use 'wbthomason/packer.nvim'
        use 'neovim/nvim-lspconfig'
        use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
        use {'Olical/conjure', tag = 'v4.12.0'}

        use 'onsails/lspkind-nvim'
        use 'j-hui/fidget.nvim'
        use 'hrsh7th/nvim-cmp'
        use 'hrsh7th/cmp-nvim-lsp'
        use 'hrsh7th/cmp-buffer'
        use 'hrsh7th/cmp-path'
        use 'L3MON4D3/LuaSnip'
        use 'saadparwaiz1/cmp_luasnip'

        use 'folke/tokyonight.nvim'
        use 'tpope/vim-commentary'
        use 'norcalli/nvim_utils'

        -- TODO(archaengel): Switch to efm for formatting and more
        use 'sbdchd/neoformat'
        -- Was autodetecting netrw windows sh filetype. Let's turn it off for a
        -- bit and see if anything breasks
        -- use 'sheerun/vim-polyglot'
        use 'kovisoft/paredit'
        use 'p00f/nvim-ts-rainbow'
        use 'fladson/vim-kitty'
        use {
            'nvim-telescope/telescope.nvim',
            requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
        }
        use {'NTBBloodbath/rest.nvim', requires = {'nvim-lua/plenary.nvim'}}
        use 'nvim-telescope/telescope-fzy-native.nvim'
        use 'nvim-telescope/telescope-symbols.nvim'
        use 'lewis6991/impatient.nvim'
        use {
            'NTBBloodbath/galaxyline.nvim',
            branch = 'main',
            -- your statusline
            config = function() end,
            -- some optional icons
            requires = {'kyazdani42/nvim-web-devicons', opt = true}
        }
    end,
    -- Move packer_compiled.lua to lua directory.
    config = {
        compile_path = vim.fn.stdpath('config') .. '/lua/packer_compiled.lua',
        display = {open_fn = require'packer.util'.float}
    }
}
