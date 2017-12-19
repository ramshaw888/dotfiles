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

" Up/down/left/right {{{
    nnoremap h h|xnoremap h h|onoremap h h|
    nnoremap n j|xnoremap n j|onoremap n j|
    nnoremap e k|xnoremap e k|onoremap e k|
    nnoremap i l|xnoremap i l|onoremap i l|
" }}}
" Words forward/backward {{{
    " l/L = back word/WORD
    " u/U = end of word/WORD
    " y/Y = forward word/WORD
  "  nnoremap l b|xnoremap l b|onoremap l b|
  "  nnoremap L B|xnoremap L B|onoremap L B|
  "  nnoremap u e|xnoremap u e|onoremap u e|
  "  nnoremap U E|xnoremap U E|onoremap U E|
  "  nnoremap y w|xnoremap y w|onoremap y w|
  "  nnoremap Y W|xnoremap Y W|onoremap Y W|
  "  cnoremap <C-L> <C-Left>
  "  cnoremap <C-Y> <C-Right>
" }}}
" inSert/Replace/append (T) {{{
    nnoremap s i|
    nnoremap S I|

  "  nnoremap t A|
   " nnoremap T A|
" }}}
" Change {{{
    nnoremap w c|xnoremap w c|
    nnoremap W C|xnoremap W C|
    nnoremap ww cc|

" }}}
" Cut/copy/pneinneaste {{{
  "  nnoremap x x|xnoremap x d|
  "  nnoremap c y|xnoremap c y|uuuuuuuuT
  "  nnoremap v p|xnoremap v p|
  "  nnoremap X dd|xnoremap X d|
  "  nnoremap C yy|xnoremap C y|
  "  nnoremap V P|xnoremap V P|
  "  nnoremap gv gp|xnoremap gv gp|
  "  nnoremap gV gP|xnoremap gV gP|
" }}}
" Undo/redo {{{
    "nnoremap z u|xnoremap z :<C-U>undo<CR>|
    "nnoremap gz U|xnoremap gz :<C-U>undo<CR>|
    "nnoremap Z <C-R>|xnoremap Z :<C-U>redo<CR>|
" }}}
" Visual mode {{{
  "  nnoremap a v|xnoremap a v|
  "  nnoremap A V|xnoremap A V|
    nnoremap ga gv
    " Make insert/add work also in visual line mode like in visual block mode
    xnoremap <silent> <expr> s (mode() =~# "[V]" ? "\<C-V>0o$I" : "I")
    xnoremap <silent> <expr> S (mode() =~# "[V]" ? "\<C-V>0o$I" : "I")
    xnoremap <silent> <expr> t (mode() =~# "[V]" ? "\<C-V>0o$A" : "A")
    xnoremap <silent> <expr> T (mode() =~# "[V]" ? "\<C-V>0o$A" : "A")
" }}}
" Search {{{
    " f/F are unchanged
  "  nnoremap p t|xnoremap p t|onoremap p t|
  "  nnoremap P T|xnoremap P T|onoremap P T|
  "  nnoremap b ;|xnoremap b ;|onoremap b ;|
  "  nnoremap B ,|xnoremap B ,|onoremap B ,|
  "  nnoremap k n|xnoremap k n|onoremap k n|
  "  nnoremap K N|xnoremap K N|onoremap K N|
" }}}
" inneR text objects {{{
    " E.g. dip (delete inner paragraph) is now drp
    onoremap r i
" }}}
" Folds, etc. {{{
    nnoremap j z|xnoremap j z|
    nnoremap jn zj|xnoremap jn zj|
    nnoremap je zk|xnoremap je zk|
" }}}
" Overridden keys must be prefixed with g {{{
    nnoremap gX X|xnoremap gX X|
    nnoremap gK K|xnoremap gK K|
    nnoremap gL L|xnoremap gL L|
" }}}
" Window handling {{{
    nnoremap <C-W>h <C-W>h|xnoremap <C-W>h <C-W>h|
    nnoremap <C-W>n <C-W>j|xnoremap <C-W>n <C-W>j|
    nnoremap <C-W>e <C-W>k|xnoremap <C-W>e <C-W>k|
    nnoremap <C-W>i <C-W>l|xnoremap <C-W>i <C-W>l|
" }}}
