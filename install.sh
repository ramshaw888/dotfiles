git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell

ln -s `pwd`/shell ~/.shell
ln -s `pwd`/shell/zshrc ~/.zshrc
ln -s `pwd`/shell/bashrc ~/.bashrc

# Initialise for autocompletion
rm -f ~/.zcompdump; compinit
