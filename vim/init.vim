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

" Common whitespace/indentation settings
set tabstop=2
set softtabstop=4
set shiftwidth=4
set autoindent
set fileformat=unix
set textwidth=120
set colorcolumn=120
set expandtab

" file type specific overwrites
au BufNewFile,BufRead *.py set tabstop=4 | set textwidth=79 | set colorcolumn=79 | set expandtab
au BufNewFile,BufRead *.js set softtabstop=2 | set shiftwidth=2 | set expandtab
au BufNewFile,BufRead *.jsx set softtabstop=2 | set shiftwidth=2 | set expandtab
au BufNewFile,BufRead *.ts set softtabstop=2 | set shiftwidth=2 | set expandtab
au BufNewFile,BufRead *.tsx set softtabstop=2 | set shiftwidth=2 | set expandtab
au BufNewFile,BufRead *.go set expandtab! | set tabstop=4
au BufNewFile,BufRead *.graphqls setfiletype graphql
au BufNewFile,BufRead *.graphql setfiletype graphql
au BufNewFile,BufRead *.gql setfiletype graphql

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
call plug#end()

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

" gruvbox
set termguicolors
"set background=dark    " Setting dark mode
set background=light   " Setting light mode
let g:gruvbox_contrast_light = 'medium'
autocmd vimenter * colorscheme gruvbox

" FZF
" layout for all vim fzf windows
"let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'relative': v:true } }
let g:fzf_layout = { 'down': '30%' }

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

let g:coc_fzf_preview = ''
let g:coc_fzf_opts = []

" COC
map <leader>g <Plug>(coc-definition)
map <leader>f <Plug>(coc-references)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gy <Plug>(coc-type-definition)

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

nmap <Leader><Space> :Agg <CR>
nmap <Leader>i :call <C-u>CocCommand editor.action.organizeImport<CR>
"nmap <Enter> :CocFzfList commands<CR>
nmap <Space> :GoDecls<CR>

autocmd FileType go nmap <Leader>t :call <C-u>CocCommand go.test.toggle<CR>
autocmd FileType go nmap gtt :call <C-u>CocCommand go.tags.add<CR>

" vim-gutter settings
set updatetime=100
nmap ;] <Plug>(GitGutterNextHunk)
nmap ;[ <Plug>(GitGutterPrevHunk)
nmap <Leader>= <Plug>(GitGutterStageHunk)
nmap <Leader>- <Plug>(GitGutterUndoHunk)
nmap <Leader>; <Plug>(GitGutterPreviewHunk)

" Dont auto wrap
set formatoptions-=t

" treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true
  },
}
EOF

" Call a zsh function from dotfiles
function! UserCall(cmd)
  let output = system("source $HOME/.dotfiles/zsh/functions.zsh && " . a:cmd)
  " Remove the '^@' from the end
  let output =substitute(output, '.$', '', '')
  return output
endfunction

" CTRL-F to open fzf with the current repository
function! s:fzfdir() abort
  let command="ag -g . " . UserCall("git_dir_cdup")
  let opts = { 'source': command, 'options': [] }
  call fzf#run(fzf#wrap('FZF', opts))
endfunction

command! FZ call s:fzfdir()
nmap <C-f> :FZ<CR>

function! s:sinkfn(dirname)
  " cd into the directory, and open the explorer there
  exe 'cd' "$CODEDIR/" . a:dirname
  exe 'e' "$CODEDIR/" .a:dirname
endfunction

" CTRL-Y to open fzf with a list of repositories
function! s:repocd() abort
  let source = split(UserCall("lsrepos"))
  call fzf#run({'source': source, 'sink': function('s:sinkfn')})
endfunction

command! RepoCd call s:repocd()
nmap <C-y> :RepoCd<CR>

command! -bang -nargs=* Agg
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)

nmap pdb :put = 'import ipdb; ipdb.set_trace()' <CR>
nmap spew :put = '  \"github.com/davecgh/go-spew/spew\"' <CR>

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
