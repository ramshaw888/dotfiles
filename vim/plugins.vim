if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

set nocompatible

call plug#begin('~/.config/nvim/plugins')

Plug 'tpope/vim-fugitive'
Plug 'Valloric/YouCompleteMe'
Plug 'nphoff/wells-colorscheme.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'nvie/vim-flake8'
Plug 'editorconfig/editorconfig-vim'
Plug 'rking/ag.vim'
Plug 'keith/Swift.vim', { 'for': 'swift' }
Plug 'leafgarland/typescript-vim', { 'for': ['ts', 'tsx'] }

call plug#end()
