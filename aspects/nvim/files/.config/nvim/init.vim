let mapleader=","

if &loadplugins
  if has('packages')
    packadd! base16-vim
    packadd! coc.nvim
    packadd! vim-fish
    packadd! vim-airline
    packadd! base16-vim-airline-themes
  endif
endif

filetype indent plugin on
syntax on
