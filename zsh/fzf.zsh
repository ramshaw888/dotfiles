# Auto-completion (vendor)
[[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings (vendor)
source "$HOME/.fzf/shell/key-bindings.zsh"

# override default CTRL-T to CTRL-F so we can use the same binding inside vim
bindkey '^F' fzf-file-widget
bindkey '^U' fzf-cd-widget

export FZF_DEFAULT_COMMAND="ag -g . \$(git_dir_cdup)"  # only filenames
export FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-75%} +m --reverse"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS"

# CTRL-P fuzzy history search
fuzzy_history() {
  # +s dont sort the result, --tac reverse the order of input (most recent hist entries first)
  print -z $( ([ -n "$ZSH_NAME" ] && fc -ln 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
  zle accept-line
}
zle -N fuzzy_history
bindkey '^p' fuzzy_history


# CTRL-Y List all git repositories, and then cd into the selected one
repo_cd() {
  repos=$( lsrepos )
  selected_dir=$( echo $repos | fzf +s --tac )
  if [[ ! -z $selected_dir ]]; then
    cd $selected_dir
    zle accept-line
  fi
}
zle -N repo_cd
bindkey '^y' repo_cd

# CTRL-K open diary (from selfrc)
zle -N diary
bindkey '^k' diary
