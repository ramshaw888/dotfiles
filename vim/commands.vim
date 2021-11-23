function! UserCall(cmd)
  let output = system("source $HOME/.dotfiles/zsh/functions.zsh && " . a:cmd)
  " Remove the '^@' from the end
  let output =substitute(output, '.$', '', '')
  return output
endfunction

" CTRL-F to open fzf with the current repository
function! s:fzfdir() abort
  let command="ag -g . " . UserCall("git_dir_cdup")
  let opts = { 'source': command, 'options': [] }
  call fzf#run(fzf#wrap('FZF', opts))
endfunction

command! FZ call s:fzfdir()
nmap <C-f> :FZ<CR>

function! s:sinkfn(dirname)
  " cd into the directory, and open the explorer there
  exe 'cd' a:dirname
  exe 'e' a:dirname
endfunction

" CTRL-Y to open fzf with a list of repositories
function! s:repocd() abort
  let source = split(UserCall("lsrepos"))
  call fzf#run({'source': source, 'sink': function('s:sinkfn')})
endfunction

command! RepoCd call s:repocd()
nmap <C-y> :RepoCd<CR>

command! -bang -nargs=* Agg
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)

nmap pdb :put = 'import ipdb; ipdb.set_trace()' <CR>
nmap spew :put = '  \"github.com/davecgh/go-spew/spew\"' <CR>

" Restart the go language server
nmap goboot :call go#lsp#Restart() <CR>

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
