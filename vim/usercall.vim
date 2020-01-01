" Use this to call functions defined in functions.zsh from vimscript

function! UserCall(cmd)
  let output = system("source $HOME/.zsh/functions.zsh && " . a:cmd)
  " Remove the '^@' from the end
  let output =substitute(output, '.$', '', '')
  return output
endfunction
