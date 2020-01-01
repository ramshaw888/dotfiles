# Auto-completion (vendor)
[[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings (vendor)
source "$HOME/.fzf/shell/key-bindings.zsh"

# CTRL-P fuzzy history search
fuzzy_history() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -ln 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}
zle -N fuzzy_history
bindkey '^p' fuzzy_history

# CTRL-F file search
file_search() {
  filename=$( ag -g . | fzf +s --tac --preview 'head -n 100 {}' | sed 's/ *[0-9]* *//')
  # filename may be empty if user exits fzf without selecting a file
  if [[ ! -z $filename ]]; then
    $EDITOR $filename
  fi
}
zle -N file_search
bindkey '^f' file_search

# List all git repositories, and then cd into the selected one
repo_cd() {
  top_level_dirs=$( find $CODEDIR -type d -maxdepth 1 | while read dir; do [ -d "$dir/.git" ] && echo $dir ; done )
  selected_dir=$( echo $top_level_dirs | fzf +s --tac )

  if [[ ! -z $selected_dir ]]; then
    cd $selected_dir
    zle accept-line
  fi
}
zle -N repo_cd
bindkey '^y' repo_cd
