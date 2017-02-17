set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'kien/ctrlp.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'wellsjo/wellsokai.vim'
Plugin 'bigfish/vim-js-context-coloring'
Plugin 'junegunn/fzf.vim'
Plugin 'bling/vim-airline'

" All of your Plugins must be added before the following line
call vundle#end()
filetype plugin indent on

:set number
:set mouse=a
:set tabstop=2
:set shiftwidth=2
:set tabpagemax=100
:set expandtab
:set list

" makes webpack livereload work
:set backupcopy=yes

" turns vim-airline on
:set laststatus=2
syntax enable

colorscheme wells-colors


hi Normal ctermbg=none

nnoremap <C-y> "+y
vnoremap <C-y> "+y
nnoremap <C-p> "+gP
vnoremap <C-p> "+gP

command! -nargs=* -bar -bang -count=0 -complete=dir E Explore <args>
