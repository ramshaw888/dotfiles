FROM ubuntu:18.04
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:neovim-ppa/stable
RUN apt-get update
RUN apt-get install -y zsh
RUN apt-get install -y neovim
RUN apt-get install -y git
RUN apt-get install -y curl
RUN apt-get install -y jq
WORKDIR /root
RUN mkdir .config
RUN git clone https://github.com/chriskempson/base16-shell.git .config/base16-shell

COPY zsh .zsh
RUN ln -sf .zsh/zshrc .zshrc

COPY lesskey_input .lesskey_input
RUN lesskey -o .less .lesskey_input

COPY vim .vim
RUN mkdir .config/nvim
RUN ln -s $HOME/.vim/vimrc $HOME/.config/nvim/init.vim
RUN vim +PlugInstall +qall

cmd zsh
