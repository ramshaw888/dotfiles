# Auto-completion (vendor)
[[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings (vendor)
source "$HOME/.fzf/shell/key-bindings.zsh"

# override default CTRL-T to CTRL-F so we can use the same binding inside vim
bindkey '^F' fzf-file-widget
bindkey '^U' fzf-cd-widget

export FZF_DEFAULT_COMMAND="ag -g . \$(git_dir_cdup)"  # only filenames
export FZF_DEFAULT_OPTS="+s --tac --height ${FZF_TMUX_HEIGHT:-75%} +m --reverse"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS --preview 'head -n 100 {}'"

# CTRL-P fuzzy history search
fuzzy_history() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -ln 1 || history) | fzf | sed 's/ *[0-9]* *//')
  zle accept-line
}
zle -N fuzzy_history
bindkey '^p' fuzzy_history


# CTRL-Y List all git repositories, and then cd into the selected one
repo_cd() {
  top_level_dirs=$( find $CODEDIR -type d -maxdepth 1 )

  # Assume all golang repos will be at level 3 e.g.
  # src/github.com/ramshaw888/repo_name, probably not the most correct method
  top_level_dirs+=$( find $GOPATH/src -type d -maxdepth 3 )

  # Only return directories that are git repositories
  top_level_dirs=$( echo $top_level_dirs | while read dir; do [ -d "$dir/.git" ] && echo $dir ; done )
  selected_dir=$( echo $top_level_dirs | fzf +s --tac )

  if [[ ! -z $selected_dir ]]; then
    cd $selected_dir
    zle accept-line
  fi
}
zle -N repo_cd
bindkey '^y' repo_cd
