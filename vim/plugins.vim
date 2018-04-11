set nocompatible
filetype off

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-fugitive', { 'on' : [] }
Plug 'Valloric/YouCompleteMe'
Plug 'nphoff/wells-colorscheme.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'nvie/vim-flake8'
Plug 'editorconfig/editorconfig-vim'
Plug 'rking/ag.vim'
Plug 'keith/Swift.vim', { 'for': 'swift' }
Plug 'leafgarland/typescript-vim', { 'for': ['ts', 'tsx'] }

call plug#end()

filetype plugin indent on


command! Gstatus call LazyLoadFugitive('Gstatus')
command! Gdiff call LazyLoadFugitive('Gdiff')
command! Glog call LazyLoadFugitive('Glog')
command! Gblame call LazyLoadFugitive('Gblame')

function! LazyLoadFugitive(cmd)
  call plug#load('vim-fugitive')
  call fugitive#detect(expand('%:p'))
  exe a:cmd
endfunction
