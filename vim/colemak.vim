" NOTE: This file should be compatible with vanilla vim, should be able to
" stick this into a remove server wihtout compatibility issues

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

:command WQ wq
:command Wq wq
:command W w
:command Q q

command! -nargs=* -bar -bang -count=0 -complete=dir E Explore <args>
