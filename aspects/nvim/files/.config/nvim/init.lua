local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local opt = vim.opt

require('mapings')

g.mapleader = " "

_G.mapper.imap('jk', '<Esc>')
_G.mapper.imap('jw', '<Esc>:w<CR>')
_G.mapper.imap('jl', '<Esc>la')
_G.mapper.imap('js', '<Esc>$a')
_G.mapper.imap('j;', '<Esc>$a;<Esc>')
_G.mapper.imap('j,', '<Esc>$a,<Esc>')
_G.mapper.imap('jo', '<Esc>o')
_G.mapper.imap('jO', '<Esc>O')

_G.mapper.lmap('w', ':w<cr>')

-- filetype indent plugin on
-- syntax on

cmd([[ source ~/.vimrc_background ]])

opt.backspace = { "indent", "eol", "start" }
opt.clipboard = "unnamedplus"
opt.completeopt = "menuone,noselect"
opt.cursorline = true
opt.encoding = "utf-8"
opt.foldenable = false
opt.foldmethod = "indent"
opt.formatoptions = "1"
opt.hidden = true
opt.hlsearch = true
opt.ignorecase = true
opt.inccommand = "split"
opt.incsearch = true
opt.joinspaces = false
opt.linebreak = true
opt.list = false
opt.number = true -- Show line numbers
opt.relativenumber = true -- Show line numbers
opt.numberwidth = 5 -- Make the gutter wider by default
opt.scrolloff = 4 -- Lines of context
opt.shiftround = true -- Round indent
opt.shiftwidth = 4 -- Size of an indent
opt.showmode = false -- Don't display mode
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes:1" -- always show signcolumns
opt.smartcase = true -- Do not ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = "en"
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.tabstop = 4 -- Number of spaces tabs count for
opt.termguicolors = true -- You will have bad experience for diagnostic messages when it's default 4000.
opt.updatetime = 250 -- don't give |ins-completion-menu| messages.
opt.wrap = true


