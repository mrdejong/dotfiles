scriptencoding utf-8

set autoindent
set backspace=indent,start,eol

set nobackup
set nowritebackup

if exists('+colorcolumn')
  let &l:colorcolumn='+' . join(range(0, 254), ',+')
endif

set cursorline
set diffopt+=foldcolumn:0

set noswapfile

set hidden

if exists('&inccommand')
  set inccommand=split
endif

set laststatus=2
set lazyredraw

if has('linebreak')
  set linebreak
endif

set list
set listchars=nbsp:⦸
set listchars+=tab:▷┅

set listchars+=extends:»
set listchars+=precedes:«
set listchars+=trail:•
set modelines=5
set nojoinspaces
set number
set relativenumber

set scrolloff=3
set shell=sh
set noshiftround
set shiftwidth=2
set shortmess+=A
set shortmess+=I
set shortmess+=O
set shortmess+=T
set shortmess+=W
set shortmess+=a
set shortmess+=o
set shortmess+=t

set sidescroll=0
set sidescrolloff=3
set smarttab

set splitbelow
set splitright

set expandtab
set tabstop=2
set softtabstop=2

if has('termguicolors')
  set termguicolors
endif

set textwidth=80

if has('nvim')
  set shell=$SHELL
endif
