# Dotfiles

Command line configs. See `Dockerfile` for setup guidelines.

## Keyboard shortcuts

These main shortcuts for `fzf` should be implemented in both `zsh` and `vim`.

- CTRL-P - search command history
- CTRL-F - search files in the current repository, or directory
- CTRL-Y - cd into a repository
- CTRL-U - cd into a directory

## Setup

```
ln -sf $(pwd) $HOME/.dotfiles
ln -sf $HOME/.dotfiles/zsh/zshrc $HOME/.zshrc
ln -sf $HOME/.dotfiles/vim $HOME/.config/nvim
git clone https://github.com/chriskempson/base16-shell.git $HOME/.config/base16-shell
ln -sf $HOME/code/ramshaw888/selfrc $HOME/.selfrc
```
