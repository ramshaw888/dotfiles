autoload -Uz promptinit
promptinit
setopt promptsubst

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`')'
}

function git_prompt() {
  local ref="$(git rev-parse --symbolic-full-name --abbrev-ref HEAD 2>/dev/null)"
  if [ -n "$ref" ]; then
    echo "(%{$fg_bold[magenta]%}${ref#refs/heads/}%{$reset_color%}) "
  fi
}

PROMPT='$(git_prompt)%{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%} $ '
RPROMPT=''
