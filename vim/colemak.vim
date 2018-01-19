" Up/down/left/right
nnoremap h h|xnoremap h h|onoremap h h|
nnoremap n j|xnoremap n j|onoremap n j|
nnoremap e k|xnoremap e k|onoremap e k|
nnoremap i l|xnoremap i l|onoremap i l|
nnoremap k n|xnoremap k n|onoremap k n|

" inSert/Replace/append
nnoremap s i|
nnoremap S I|

" Change
nnoremap w c|xnoremap w c|
nnoremap W C|xnoremap W C|
nnoremap ww cc|

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
