function base {
  if [ ! -d $HOME/.config ]; then
    mkdir $HOME/.config
  fi
}

function shell {
  base
  git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell

  ln -s `pwd`/shell ~/.shell
  ln -s `pwd`/shell/zshrc ~/.zshrc
  ln -s `pwd`/shell/bashrc ~/.bashrc

  # Initialise for autocompletion
  rm -f ~/.zcompdump; compinit
}

function vim {
  base
  if [ ! -d $HOME/.config/nvim ]; then
    mkdir $HOME/.config/nvim
  fi
  ln -s `pwd`/vimrc $HOME/.config/nvim/init.vim
}

case $1 in
  "shell")
    shell
    ;;
  "vim")
    vim
    ;;
  *)
    echo "install vim, shell"
    ;;
esac
