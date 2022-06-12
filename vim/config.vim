" PLUGINS
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugins')
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'antoinemadec/coc-fzf'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf' } " assume that fzf has already been installed
  Plug 'junegunn/fzf.vim'
  Plug 'morhetz/gruvbox'
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
call plug#end()

let vimrcdir = '$HOME/.dotfiles/vim/'
exec ':source ' . vimrcdir . 'colemak.vim'

set number
set mouse=a
set tabstop=2
set shiftwidth=2
set expandtab
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
set tabstop=2
set softtabstop=4
set shiftwidth=4
set autoindent
set fileformat=unix
set textwidth=120
set colorcolumn=120
set expandtab

au BufNewFile,BufRead *.py set tabstop=4 | set textwidth=79 | set colorcolumn=79 | set expandtab
au BufNewFile,BufRead *.js set softtabstop=2 | set shiftwidth=2 | set expandtab
au BufNewFile,BufRead *.jsx set softtabstop=2 | set shiftwidth=2 | set expandtab
au BufNewFile,BufRead *.ts set softtabstop=2 | set shiftwidth=2 | set expandtab
au BufNewFile,BufRead *.tsx set softtabstop=2 | set shiftwidth=2 | set expandtab
au BufNewFile,BufRead *.vim set softtabstop=2 | set shiftwidth=2 | set expandtab
au BufNewFile,BufRead *.go set expandtab! | set tabstop=4
au BufNewFile,BufRead *.graphqls setfiletype graphql
au BufNewFile,BufRead *.graphql setfiletype graphql
au BufNewFile,BufRead *.gql setfiletype graphql

" gruvbox
set termguicolors
"set background=dark    " Setting dark mode
set background=light   " Setting light mode
let g:gruvbox_contrast_light = 'medium'
autocmd vimenter * colorscheme gruvbox

nnoremap <C-f> <cmd>lua require('telescope.builtin').git_files()<cr>
nnoremap <C-y> :call v:lua.repositories()<cr>
nnoremap <leader>fs <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

function! ChangeDir(dirname)
  " cd into the directory, and open the explorer there
  exe 'cd' "$CODEDIR/" . a:dirname
  exe 'e' "$CODEDIR/" .a:dirname
  lua require('telescope.builtin').git_files()
endfunction

let g:coc_global_extensions = [
\  'coc-tsserver',
\  'coc-prettier',
\  'coc-go',
\  'coc-sh',
\  'coc-eslint',
\  'coc-yaml',
\  'coc-json',
\  'coc-toml',
\  'coc-vimlsp',
\ ]

" COC
map <leader>g <Plug>(coc-definition)
map <leader>f <Plug>(coc-references)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gy <Plug>(coc-type-definition)

" K on symbol - show documentation
nmap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute ':vertical h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

nmap <silent> ac  <Plug>(coc-codeaction-selected)
vmap <silent> ac  <Plug>(coc-codeaction-selected)

autocmd FileType go nmap <Leader>t :call <C-u>CocCommand go.test.toggle<CR>
autocmd FileType go nmap gtt :call <C-u>CocCommand go.tags.add<CR>

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" END COC

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


" FZF

command! -bang -nargs=* Agg
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)

nmap <Leader><Space> :Agg <CR>
nmap <Space> :GoDecls<CR>
