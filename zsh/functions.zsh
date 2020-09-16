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

lsrepos() {
  repos=$( find $CODEDIR -type d -maxdepth 1 )

  # Assume all golang repos will be at level 3 e.g.
  # src/github.com/ramshaw888/repo_name, probably not the most correct method
  repos+="\n$( find $GOPATH/src -type d -maxdepth 3 )"

  # Only return directories that are git repositories
  repos=$( echo $repos | while read dir; do [ -d "$dir/.git" ] && echo $dir ; done )
  echo $repos
}

1p() {
  eval $(op signin my)
}
