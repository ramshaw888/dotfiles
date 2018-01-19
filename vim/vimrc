let vimrcdir = "$HOME/code/dotfiles/vim/"
for s:script_name in split(globpath(vimrcdir, '*.vim'))
    exec ":source " . s:script_name
endfor

let g:python2_host_prog = '/usr/local/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'

set t_Co=256
:set number
:set mouse=a
:set tabstop=2
:set shiftwidth=2
:set tabpagemax=100
:set expandtab
:set list


nnoremap <C-y> "+y
vnoremap <C-y> "+y
nnoremap <C-p> "+gP
vnoremap <C-p> "+gP
set hidden
nnoremap <Tab> <C-^><CR>

nmap <C-p> :FZF ~/code<CR>

" makes webpack livereload work
:set backupcopy=yes

syntax enable

colorscheme wells-colors

hi Normal ctermbg=none

set backspace=start,eol,indent

set clipboard=unnamed
