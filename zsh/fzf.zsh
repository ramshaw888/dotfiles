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
  filename=$( find * -type f | fzf +s --tac | sed 's/ *[0-9]* *//')
  # filename may be empty if user exits fzf without selecting a file
  if [[ ! -z $filename ]]; then
    $EDITOR $filename
  fi
}
zle -N file_search
bindkey '^f' file_search
