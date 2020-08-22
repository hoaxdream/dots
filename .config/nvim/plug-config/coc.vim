" Global extensions
let g:coc_global_extensions = [
  \ 'coc-highlight',
  \ 'coc-dictionary',
  \]

" Language extensions
let g:coc_global_extensions += [
  \ 'coc-css',
  \]

" Auto open explorer
"autocmd User CocNvimInit :CocCommand explorer

" If coc-explorer is last buffer - exit
"autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif

" Key mappings
" Use tab for trigger completion with characters ahead and navigate
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
