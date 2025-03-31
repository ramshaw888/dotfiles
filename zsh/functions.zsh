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
  repos=$( find $CODEDIR -type d -maxdepth 2 )

  # Only return directories that are git repositories
  repos=$( echo $repos | while read dir; do [ -d "$dir/.git" ] && echo ${dir#"$CODEDIR/"}; done )
  echo $repos"\n"$(extraRepos)
}

findreplace() {
    if [ $# -ne 2 ]; then
        echo "Usage: findreplace \"text_to_find\" \"text_to_replace\""
        return 1
    fi

    # Check if ag is installed
    if ! command -v ag >/dev/null 2>&1; then
        echo "Error: ag (The Silver Searcher) is not installed."
        echo "Install it with: brew install ag (on macOS with Homebrew)"
        return 1
    fi

    local search_pattern="$1"
    local replace_text="$2"
    local current_dir="$(pwd)"

    # First show which files will be affected (preview) using ag
    echo "Files that will be modified:"
    ag -l "$search_pattern" "$current_dir"
    ag -l "$search_pattern" "$current_dir" | xargs perl -i -pe "s/$search_pattern/$replace_text/g"
}
