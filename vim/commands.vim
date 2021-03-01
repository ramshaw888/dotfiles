:command WQ wq
:command Wq wq
:command W w
:command Q q

command! -nargs=* -bar -bang -count=0 -complete=dir E Explore <args>

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
