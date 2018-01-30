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
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}
zle -N fh
bindkey '^r' fh
