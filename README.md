# Dotfiles

Command line configs. See `Dockerfile` for setup guidelines.


## Keyboard shortcuts

These main shortcuts for `fzf` should be implemented in both `zsh` and `vim`.

* CTRL-P - search command history
* CTRL-F - search files in the current repository, or directory
* CTRL-Y - cd into a repository
* CTRL-U - cd into a directory

## Symlinks

```
ln -sf $HOME/code/dotfiles/zsh/zshrc $HOME/.zshrc
ln -sf $HOME/code/dotfiles/zsh $HOME/.zsh
lesskey -o $HOME/.less lesskey_input
mkdir $HOME/.config/nvim
ln -sf $HOME/code/dotfiles/vim $HOME/.vim
ln -sf $HOME/code/dotfiles/vim/vimrc $HOME/.config/nvim/init.vim
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install --bin
ln -sf $HOME/.fzf/bin/fzf /usr/local/bin/fzf
git clone https://github.com/chriskempson/base16-shell.git $HOME/.config/base16-shell
```

## Mac dependencies

```
brew install neovim
brew install less
brew install fzf
brew install gpg
brew install the_silver_searcher
```
