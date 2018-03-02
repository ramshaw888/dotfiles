#!/bin/bash

# Always rm symlinks before creating one - `ln -s` assumes symlink does not
# already exist


function base {
  if [ ! -d $HOME/.config ]; then
    mkdir $HOME/.config
  fi
}

function shell {
  base
  git clone https://github.com/chriskempson/base16-shell.git $HOME/.config/base16-shell

  rm $HOME/.shell
  ln -s `pwd`/shell $HOME/.shell
  rm $HOME/.zshrc
  ln -s `pwd`/shell/zshrc $HOME/.zshrc

  # Initialise for autocompletion
  rm -f $HOME/.zcompdump
  zsh -c "source `pwd`/shell/zshrc; compinit"
}

function vim {
  base
  if [ ! -d $HOME/.config/nvim ]; then
    mkdir $HOME/.config/nvim
  fi
  rm $HOME/.config/nvim/init.vim
  ln -s `pwd`/vim/vimrc $HOME/.config/nvim/init.vim
}

function less {
  lesskey -o $HOME/.less lesskey
}

case $1 in
  "shell")
    shell
    ;;
  "vim")
    vim
    ;;
  "less")
    less
    ;;
  *)
    echo "install vim, shell, less"
    ;;
esac
