FROM ubuntu:18.04
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:neovim-ppa/stable
RUN apt-get update
RUN apt-get install -y zsh
RUN apt-get install -y neovim
RUN apt-get install -y git
RUN apt-get install -y curl
cmd zsh
