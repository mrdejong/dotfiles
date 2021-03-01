let g:BufferNameBlacklist = ['__LanguageClient__']
let g:FileTypeBlacklist = ['command-t', 'diff']

if has('autocmd')
  function! s:DutchCaffeineAutocmds()
    augroup DutchCaffeineAutocmds
      autocmd!

      autocmd InsertLeave * set nopaste

      autocmd BufWritePre * call s:strip_trailing_whitespace()
      autocmd TermOpen * setlocal nonumber norelativenumber

      autocmd InsertEnter * set nocul
      autocmd InsertLeave * set cul

      autocmd BufEnter,FocusGained,VimEnter,WinEnter * call s:focus_window()
      autocmd FocusLost,WinLeave * call s:blur_window()
    augroup END
  endfunction

  function! s:strip_trailing_whitespace()
    if &modifiable
      let l:l = line('.')
      let l:c = col('.')
      call execute('%s/\s\+$//e')
      call histdel('/', -1)
      call cursor(l:l, l:c)
    endif
  endfunction

  function! s:should_colorcolumn() abort
    if index(g:BufferNameBlacklist, bufname(bufnr('%'))) != -1
      return 0
    endif
    return index(g:FileTypeBlacklist, &filetype) == -1
  endfunction

  function! s:focus_window() abort
    if s:should_colorcolumn()
      if !empty(&ft)
        ownsyntax
      endif
    endif
  endfunction

  function! s:blur_window() abort
    if s:should_colorcolumn()
      ownsyntax off
    endif
  endfunction

  call s:DutchCaffeineAutocmds()
endif
