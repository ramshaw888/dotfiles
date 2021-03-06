if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

set nocompatible

" These need to go before ale is loaded
let g:ale_linters = {}
let g:ale_linters.go = ['gotype', 'gometalinter', 'gofmt', 'gobuild', 'goimports']
let g:ale_linters.typescript = ['eslint', 'tsserver']

let g:ale_fixers = {'javascript': ['prettier'], 'typescript': ['prettier']}

let g:ale_typescript_prettier_use_local_config = 1
let g:ale_fix_on_save = 1
let g:ale_linters_explicit = 1
let g:ale_go_gobuild_options = '-i'

let g:go_fmt_command="gopls"
let g:go_gopls_gofumpt=1

call plug#begin('~/.config/nvim/plugins')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-fugitive'
Plug 'nphoff/wells-colorscheme.vim'
" assume that fzf has already been installed
Plug 'junegunn/fzf', { 'dir': '~/.fzf' }
Plug 'junegunn/fzf.vim'
Plug 'nvie/vim-flake8'
Plug 'editorconfig/editorconfig-vim'
" Plug 'keith/Swift.vim', { 'for': 'swift' }
Plug 'leafgarland/typescript-vim',
Plug 'peitalin/vim-jsx-typescript'
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'dense-analysis/ale'
Plug 'scrooloose/nerdcommenter'
Plug 'chriskempson/base16-vim'
Plug 'morhetz/gruvbox'

call plug#end()
