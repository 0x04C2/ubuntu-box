#!/usr/bin/env bash
#
# ubuntu install tools

set -euo pipefail

# all commands are running without interactive
#
# fix "dpkg-reconfigure: unable to re-open stdin: No file or directory" error
export DEBIAN_FRONTEND=noninteractive

# install_base installs base tools.
install_base() {
  sudo apt-get install -y \
    wget \
    curl \
    unzip \
    zip \
    tree \
    tar \
    \
    zsh \
    vim \
    neovim \
    tmux \
    \
    git \
    gcc \
    cmake \
    make \
    \
    lsof
}

# install_golang_v1_9 installs golang v1.9 binary.
#
# Note that golang-1.9-go puts binaries in /usr/lib/go-1.9/bin, but no in the
# PATH.
install_golang_v1_9() {
  sudo apt-get install golang-1.9-go -y
}

# install_docker_ce installs docker-ce
install_docker_ce() {
  sudo apt-get install docker-ce -y
}

main() {
  install_base
  install_golang_v1_9
  install_docker_ce
}

main
