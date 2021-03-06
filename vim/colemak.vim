" hnei - Up/down/left/right
nnoremap h h|xnoremap h h|onoremap h h|
nnoremap n j|xnoremap n j|onoremap n j|
nnoremap e k|xnoremap e k|onoremap e k|
nnoremap i l|xnoremap i l|onoremap i l|

" HNEI - next/back word, up down 6 lines
nnoremap H b|xnoremap H b|onoremap H b|
nnoremap I w|xnoremap I w|onoremap I w|
nnoremap N 6j|xnoremap N 6j|onoremap N 6j|
nnoremap E 6k|xnoremap E 6k|onoremap E 6k|

" k next result
nnoremap k n|xnoremap k n|onoremap k n|
" Ctrl-k back result
nnoremap <C-k> N|xnoremap <C-W>k N|onoremap <C-W>k N|

" inSert/Replace/append
nnoremap s i|
nnoremap S I|

" Change (unused)
"nnoremap w c|xnoremap w c|
"nnoremap W C|xnoremap W C|
"nnoremap ww cc|

" Visual mode
nnoremap ga gv
" Make insert/add work also in visual line mode like in visual block mode
xnoremap <silent> <expr> s (mode() =~# "[V]" ? "\<C-V>0o$I" : "I")
xnoremap <silent> <expr> S (mode() =~# "[V]" ? "\<C-V>0o$I" : "I")
xnoremap <silent> <expr> t (mode() =~# "[V]" ? "\<C-V>0o$A" : "A")
xnoremap <silent> <expr> T (mode() =~# "[V]" ? "\<C-V>0o$A" : "A")

" inneR text objects
onoremap r i

" Folds, etc.
nnoremap j z|xnoremap j z|
nnoremap jn zj|xnoremap jn zj|
nnoremap je zk|xnoremap je zk|

" Overridden keys must be prefixed with g
nnoremap gX X|xnoremap gX X|
nnoremap gK K|xnoremap gK K|
nnoremap gL L|xnoremap gL L|

" Window handling
nnoremap <C-W>h <C-W>h|xnoremap <C-W>h <C-W>h|
nnoremap <C-W>n <C-W>j|xnoremap <C-W>n <C-W>j|
nnoremap <C-W>e <C-W>k|xnoremap <C-W>e <C-W>k|
nnoremap <C-W>i <C-W>l|xnoremap <C-W>i <C-W>l|

" Clipboard
nnoremap <C-y> "+y
vnoremap <C-y> "+y
nnoremap <C-p> "+gP
vnoremap <C-p> "+gP

nnoremap <Tab> <C-^><CR>

map <leader>g <Plug>(coc-definition)
map <leader>f <Plug>(coc-references)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gy <Plug>(coc-type-definition)

nmap <Leader><Space> :Agg <CR>
nmap <Space> :GoDecls <CR>
nmap <Leader>c :GoDeclsDir <CR>
nmap <Leader>t :GoAlternate <CR>
nmap <Leader>i :GoImports<CR>

autocmd FileType go nmap gtt :CocCommand go.tags.add json<cr>

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif
