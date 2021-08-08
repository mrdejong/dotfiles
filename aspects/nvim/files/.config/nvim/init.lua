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

cmd([[
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

let g:completion_confirm_key = ""
imap <expr> <cr>  pumvisible() ? complete_info()["selected"] != "-1" ?
                 \ "\<Plug>(completion_confirm_completion)"  : "\<c-e>\<CR>" :  "\<CR>"
]])

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

local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end

	require'completion'.on_attach(client, bufnr)

	protocol.CompletionItemKind = {
		'', -- Text
		'', -- Method
		'', -- Function
		'', -- Constructor
		'', -- Field
		'', -- Variable
		'', -- Class
		'ﰮ', -- Interface
		'', -- Module
		'', -- Property
		'', -- Unit
		'', -- Value
		'', -- Enum
		'', -- Keyword
		'﬌', -- Snippet
		'', -- Color
		'', -- File
		'', -- Reference
		'', -- Folder
		'', -- EnumMember
		'', -- Constant
		'', -- Struct
		'', -- Event
		'ﬦ', -- Operator
		'', -- TypeParameter
	}

	local opts = { noremap=true, silent=true }

	buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<cr>', opts)
	buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<cr>', opts)
end

nvim_lsp.tsserver.setup {
	on_attach = on_attach
}


local saga = require 'lspsaga'

saga.init_lsp_saga {
	error_sign = '',
	warn_sign = '', 
	hint_sign = '',
	infor_sign = '',
	border_style = "round"
}

_G.mapper.map('n', 'K', ':Lspsaga hover_doc<cr>')

require'nvim-treesitter.configs'.setup {
	highlight = {
		enable = true,
		disable = {}
	},
	indent = {
		enable = false,
		disable = {}
	},
	ensure_installed = {
		"tsx",
		"toml",
		"php",
		"json",
		"yaml",
		"html",
		"scss"
	}
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.used_by = { "javascript", "typescript.tsx" }
