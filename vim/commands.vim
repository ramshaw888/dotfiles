:command WQ wq
:command Wq wq
:command W w
:command Q q

command! -nargs=* -bar -bang -count=0 -complete=dir E Explore <args>

command! FZF call execute 'FZF ~'
