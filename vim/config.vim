if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugins')
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'morhetz/gruvbox'
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-ui-select.nvim'
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/vim-vsnip'
call plug#end()

let vimrcdir = '$HOME/.dotfiles/vim/'
exec ':source ' . vimrcdir . 'colemak.vim'

set number
set mouse=a
set tabstop=2
set shiftwidth=2
set foldmethod=syntax
set foldlevelstart=20
set foldlevel=0
set undofile
set undodir=~/.neovimundodir
set mmp=5000
set list "Show whitespace characters
set backupcopy=yes " makes webpack livereload work
set hidden " Hides current file when opening explorer
set backspace=start,eol,indent
set clipboard=unnamed
set formatoptions-=t " Dont auto wrap
set autoindent
set fileformat=unix
set textwidth=120
set colorcolumn=120
set expandtab!

au BufNewFile,BufRead *.py set tabstop=4 | set textwidth=79 | set colorcolumn=79 | set expandtab
au BufNewFile,BufRead *.js set softtabstop=2 | set shiftwidth=2 | set expandtab
au BufNewFile,BufRead *.jsx set softtabstop=2 | set shiftwidth=2 | set expandtab
au BufNewFile,BufRead *.ts set softtabstop=2 | set shiftwidth=2 | set expandtab
au BufNewFile,BufRead *.tsx set softtabstop=2 | set shiftwidth=2 | set expandtab
au BufNewFile,BufRead *.vim set softtabstop=2 | set shiftwidth=2 | set expandtab
au BufNewFile,BufRead *.lua set softtabstop=2 | set shiftwidth=2 | set expandtab
au BufNewFile,BufRead *.go set expandtab! | set tabstop=4 | set shiftwidth=4
au BufNewFile,BufRead *.graphqls setfiletype graphql
au BufNewFile,BufRead *.graphql setfiletype graphql
au BufNewFile,BufRead *.gql setfiletype graphql

" gruvbox
set termguicolors
"set background=dark    " Setting dark mode
set background=light   " Setting light mode
let g:gruvbox_contrast_light = 'medium'
autocmd vimenter * colorscheme gruvbox

autocmd FileType go nmap <Leader>t :call <C-u>CocCommand go.test.toggle<CR>
autocmd FileType go nmap gtt :call <C-u>CocCommand go.tags.add<CR>

" vim-gutter settings
set updatetime=100
nmap ;] <Plug>(GitGutterNextHunk)
nmap ;[ <Plug>(GitGutterPrevHunk)
nmap <Leader>= <Plug>(GitGutterStageHunk)
nmap <Leader>- <Plug>(GitGutterUndoHunk)
nmap <Leader>; <Plug>(GitGutterPreviewHunk)

" Call a zsh function from dotfiles
function! UserCall(cmd)
  let output = system("source $HOME/.dotfiles/zsh/functions.zsh && " . a:cmd)
  " Remove the '^@' from the end
  let output =substitute(output, '.$', '', '')
  return output
endfunction

" cd into the directory, and open the explorer there
function! ChangeDir(dirname)
  exe 'cd' "$CODEDIR/" . a:dirname
  exe 'e' "$CODEDIR/" .a:dirname
  lua require('telescope.builtin').git_files()
endfunction
