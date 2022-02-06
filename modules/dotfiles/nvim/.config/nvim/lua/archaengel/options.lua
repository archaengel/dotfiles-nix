local opt = vim.opt
local cmd = vim.cmd

opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.completeopt = "menuone,noinsert,noselect"
opt.cursorline = true
opt.colorcolumn = "80,100"
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.incsearch = true
opt.hlsearch = false
opt.scrolloff = 8
opt.ignorecase = true
opt.smartcase = true
opt.updatetime = 50
opt.listchars = "tab:> ,trail:-,nbsp:+"
opt.list = true
opt.signcolumn = "yes:1"
opt.path = "."
opt.regexpengine = 0
opt.wrap = false

-- Indentation
cmd [[
    filetype plugin on
    syntax on
]]

-- Completion Highlight
cmd [[
    highlight link CompeDocumentation NormalFloat
]]

cmd [[colorscheme tokyonight]]
cmd [[syntax on]]
opt.background = "dark"
