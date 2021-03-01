let g:coc_global_extensions = [
      \ 'coc-pairs',
      \ 'coc-json',
      \ 'coc-vimlsp',
      \ 'coc-explorer',
      \ 'coc-emmet',
      \ 'coc-rls',
      \ 'coc-rust-analyzer',
      \ 'coc-todolist',
      \ 'coc-toml',
      \ 'coc-graphql',
      \ 'coc-phpactor'
      \ ]

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<cr>\<c-r>=coc#on_enter()\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "<C-g>u\<cr>\<c-r>=coc#on_enter()\<cr>"
endif

nnoremap <leader>e :CocCommand explorer<cr>
nnoremap <leader>f :CocCommand explorer<cr>
