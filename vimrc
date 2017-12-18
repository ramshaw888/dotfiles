let g:python2_host_prog = '/usr/local/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=/usr/local/opt/fzf
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'Valloric/YouCompleteMe'
Plugin 'nphoff/wells-colorscheme.vim'
Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'nvie/vim-flake8'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'rking/ag.vim'
Plugin 'keith/Swift.vim'

" All of your Plugins must be added before the following line
call vundle#end()
filetype plugin indent on

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

" turns vim-airline on
:set laststatus=2
syntax enable

colorscheme wells-colors

hi Normal ctermbg=none

let g:airline_powerline_fonts = 1

command! -nargs=* -bar -bang -count=0 -complete=dir E Explore <args>

set backspace=start,eol,indent

command! FZF call execute 'FZF ~'

set clipboard=unnamed
