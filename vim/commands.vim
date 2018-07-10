let vimrcdir = '$HOME/code/dotfiles/vim/'
exec ':source ' . vimrcdir . 'gitdir.vim'

:command WQ wq
:command Wq wq
:command W w
:command Q q

" Clipboard
nnoremap <C-y> "+y
vnoremap <C-y> "+y
nnoremap <C-p> "+gP
vnoremap <C-p> "+gP

nnoremap <Tab> <C-^><CR>

command! -nargs=* -bar -bang -count=0 -complete=dir E Explore <args>

let git_dir = GitDir()
if (!empty(git_dir))
    let fzf_command = 'nmap <C-p> :FZF ' . git_dir . '<CR>'
else
    let fzf_command = 'nmap <C-p> :FZF .<CR>'
endif
execute fzf_command

nmap pdb :put = 'import ipdb; ipdb.set_trace()' <CR>
