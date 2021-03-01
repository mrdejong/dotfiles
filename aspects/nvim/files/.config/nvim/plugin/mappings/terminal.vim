if has('nvim')
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-j> <C-\><C-n>

  autocmd! FileType fzf tnoremap <buffer> <esc> <c-c>
endif
