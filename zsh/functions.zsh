# These functions can be easily used in vimscript by calling
# system(". $HOME/.zsh/functions.zsh && git_dir_cdup")

git_dir_cdup() {
  dir=$(git rev-parse --show-cdup 2> /dev/null)

  if [[ -z $dir ]] then
    # Return current directory if there is no repository
    echo "."
  else
    echo $dir
  fi
}

git_dir() {
  dir=$(git rev-parse --show-toplevel 2> /dev/null)
  echo $dir
}
