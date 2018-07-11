bindkey -v

bindkey -M vicmd 'i' vi-forward-char
bindkey -M vicmd 'h' vi-backward-char
bindkey -M vicmd 'e' up-history
bindkey -M vicmd 'n' down-history
bindkey -M vicmd 'E' up-line-or-history
bindkey -M vicmd 'N' down-line-or-history
bindkey -M vicmd 's' vi-insert
bindkey -M vicmd 'b' vi-backward-word
bindkey -M vicmd 'k' vi-forward-word

# fzf fuzzy history search
fuzzy_history() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -ln 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}
zle -N fuzzy_history
bindkey '^p' fuzzy_history

file_search() {
  print -z $( find * -type f | fzf +s --tac | sed 's/ *[0-9]* *//')
}

zle -N file_search
bindkey '^f' file_search
