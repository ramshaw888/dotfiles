FROM ubuntu:18.04

WORKDIR /root
RUN mkdir .config

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:neovim-ppa/stable

# Up to date python builds
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update

RUN apt-get install -y zsh
RUN apt-get install -y git
RUN apt-get install -y curl
RUN apt-get install -y jq
RUN apt-get install -y --no-install-recommends neovim

RUN apt-get install -y python2.7
RUN apt-get install -y python3.8

# Required for building c extensions (e.g. greenlet)
RUN apt-get install -y python2.7-dev
RUN apt-get install -y python3.8-dev

# Required for ycm
RUN apt-get install -y build-essential cmake

# Required for get-pip
RUN apt-get install -y python3.8-distutils

RUN curl https://bootstrap.pypa.io/get-pip.py | python2.7
RUN curl https://bootstrap.pypa.io/get-pip.py | python3.8

# RUN apt-get install -y --no-install-recommends gcc

RUN python2.7 -m pip install --user virtualenv
RUN python3.8 -m pip install --user virtualenv

# Create dedicated virtualenvs for pynvim, python_host_prog config in vim
# should point to these virtualenvs
RUN python2.7 -m virtualenv .config/py2_venv
RUN . .config/py2_venv/bin/activate && pip install pynvim && deactivate
RUN python3.8 -m virtualenv .config/py3_venv
RUN . .config/py3_venv/bin/activate && pip install pynvim && deactivate

#RUN git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
# Prefer symlink here instead of modifying path
#RUN ln -sf $HOME/.pyenv/bin/pyenv /usr/local/bin/pyenv

# Use pyenv without using it to install python - symlink in our ppa installed
# binaries.
#RUN mkdir -p $HOME/.pyenv/shims
#RUN ln -sf /usr/bin/python3.8 $HOME/.pyenv/shims/python

RUN git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
# Install fzf into ~/.fzf, and use --bin install - by default the installation
# is quite intrusive, The zsh configs for completion, bindings can be
# sourced/included manually.
RUN $HOME/.fzf/install --bin
# Add symlink to prevent pollution of PATH.
RUN ln -sf $HOME/.fzf/bin/fzf /usr/local/bin/fzf

COPY zsh .zsh
RUN ln -sf .zsh/zshrc .zshrc

COPY lesskey_input .lesskey_input
RUN lesskey -o .less .lesskey_input

RUN git clone https://github.com/chriskempson/base16-shell.git .config/base16-shell

COPY vim .vim
RUN mkdir .config/nvim
RUN ln -s $HOME/.vim/vimrc $HOME/.config/nvim/init.vim
RUN vim +PlugInstall +qall

cmd zsh
