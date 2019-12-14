# CTRL-P fuzzy history search
fuzzy_history() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -ln 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}
zle -N fuzzy_history
bindkey '^p' fuzzy_history

# CTRL-F file search
file_search() {
  vim $( find * -type f | fzf +s --tac | sed 's/ *[0-9]* *//')
}
zle -N file_search
bindkey '^f' file_search
