function! GitDir()
  let git_dir=system('git rev-parse --show-toplevel')
  " Remove the '^@' from the end
  let git_dir=substitute(git_dir, '.$', '', '')
  let invalid_git_dir=matchstr(git_dir, '^fatal:.*')
  if (empty(invalid_git_dir))
    return git_dir
  endif
  return 0
endfunction
