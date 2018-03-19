let vimrcdir = '$HOME/code/dotfiles/vim/'
exec ':source ' . vimrcdir . 'gitdir.vim'

:command WQ wq
:command Wq wq
:command W w
:command Q q

command! -nargs=* -bar -bang -count=0 -complete=dir E Explore <args>

let git_dir = GitDir()
if (!empty(git_dir))
    let fzf_command = 'nmap <C-p> :FZF ' . git_dir . '<CR>'
else
    let fzf_command = 'nmap <C-p> :FZF .<CR>'
endif
execute fzf_command
