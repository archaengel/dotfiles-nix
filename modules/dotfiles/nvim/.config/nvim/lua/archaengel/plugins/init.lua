return require('packer').startup {
    function(use)
        use 'wbthomason/packer.nvim'
        use 'tjdevries/astronauta.nvim'
        use 'neovim/nvim-lspconfig'
        use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
        use {'Olical/conjure', tag = 'v4.12.0'}
        use 'hrsh7th/nvim-compe'
        use 'folke/tokyonight.nvim'
        use 'tpope/vim-commentary'
        use 'norcalli/nvim_utils'
        -- use 'gruvbox-community/gruvbox'
        -- TODO(archaengel): Switch to efm for formatting and more
        use 'sbdchd/neoformat'
        use 'sheerun/vim-polyglot'
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
            'glepnir/galaxyline.nvim',
            branch = 'main',
            -- your statusline
            config = function() end,
            -- some optional icons
            requires = {'kyazdani42/nvim-web-devicons', opt = true}
        }
    end,
    -- Move packer_compiled.lua to lua directory.
    config = {
        compile_path = vim.fn.stdpath('config') .. '/lua/packer_compiled.lua'
    }
}
