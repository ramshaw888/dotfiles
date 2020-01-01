function! GitDir()
  let git_dir = system("source $HOME/.zsh/functions.zsh && git_dir")
  let git_dir=substitute(git_dir, '.$', '', '')
  return git_dir
endfunction

function! GitDirCdUp()
  let git_dir = system("source $HOME/.zsh/functions.zsh && git_dir_cdup")
  " Remove the '^@' from the end
  let git_dir = substitute(git_dir, '.$', '', '')
  return git_dir
endfunction
