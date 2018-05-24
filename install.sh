#!/bin/bash

# Always rm symlinks before creating one - `ln -s` assumes symlink does not
# already exist


function base {
  if [ ! -d $HOME/.config ]; then
    mkdir $HOME/.config
  fi
}

function shell_install {
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

function vim_install {
  base
  if [ ! -d $HOME/.config/nvim ]; then
    mkdir $HOME/.config/nvim
  fi
  rm $HOME/.config/nvim/init.vim
  ln -s `pwd`/vim/vimrc $HOME/.config/nvim/init.vim
}

function less_install {
  lesskey -o $HOME/.less lesskey
}

function tern_install {
  npm i -g tern-jsx
  rm $HOME/.tern-config
  ln -s `pwd`/vim/.tern-config $HOME/.tern-config
}

function gpg_install {
  gpg --list-secret-keys --keyid-format LONG
  echo "pinentry-program /usr/local/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
  gpgconf --kill gpg-agent
}

function chunkwm_install {
  brew tap crisidev/homebrew-chunkwm
  brew install koekeishiya/formulae/skhd
  brew install chunkwm
  rm $HOME/.chunkwmrc
  ln -s `pwd`/chunkwmrc $HOME/.chunkwmrc
  rm $HOME/.skhdrc
  ln -s `pwd`/skhdrc $HOME/.skhdrc
  chmod +x $HOME/.chunkwmrc
  brew services start crisidev/chunkwm/chunkwm
  brew services start koekeishiya/formulae/skhd
}

function stop_chunkwm {
  brew services stop crisidev/chunkwm/chunkwm
  brew services stop koekeishiya/formulae/skhd
}


case $1 in
  "shell")
    shell_install
    ;;
  "vim")
    vim_install
    ;;
  "less")
    less_install
    ;;
  "tern")
    tern_install
    ;;
  "gpg")
    gpg_install
    ;;
  "chunkwm")
    chunkwm_install
    ;;
  "stop_chunkwm")
    stop_chunkwm
    ;;
  *)
    echo "install vim, shell, less, tern, gpg, chunkwm, stop_chunkwm"
    ;;
esac
