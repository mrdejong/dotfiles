let g:BufferNameBlacklist = ['__LanguageClient__']
let g:FileTypeBlacklist = ['command-t', 'diff', 'coc-explorer']

let opt_DimWin=0
hi Inactive ctermfg=235

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
    if index(g:FileTypeBlacklist, &filetype) == -1
      return 0
    endif
    return &buflisted
  endfunction


  function! s:focus_window() abort
    if s:should_colorcolumn()
      if !empty(&ft)
        ownsyntax

        for i in range(1, tabpagewinnr(tabpagenr(), '$'))
          let l:range = ""
          if i != winnr()
            if &wrap
              let l:width=256
            else
              let l:width=winwidth(i)
            endif
            let l:range = join(range(1, l:width), ',')
          endif
          call setwinvar(i, '&colorcolumn', l:range)
        endfor
        call setwinvar(winnr(), '&colorcolumn', '+' . join(range(0, 254), ',+'))
      endif
      set cursorline
    endif
  endfunction

  function! s:blur_window() abort
    if s:should_colorcolumn()
      ownsyntax off
      syntax region Inactive start='^' end='$'
      set nocursorline
    endif
  endfunction

  call s:DutchCaffeineAutocmds()
endif
