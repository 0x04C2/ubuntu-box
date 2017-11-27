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

# install_golang install
#
# NOTE: go source code and binary are at /usr/local/go. Need to setup the path.
install_golang() {
  local go_src target version latest_version

  # purge old src
  go_src="/usr/local/go"
  if [[ -d "${go_src}" ]]; then
    sudo rm -rf "${go_src}"
  fi

  latest_version="$(curl -sSL "https://golang.org/VERSION?m=text")"
  set +u; version="${GO_VESION:-${latest_version}}"; set -u
  target="https://redirector.gvt1.com/edgedl/go/${version}.linux-amd64.tar.gz"

  curl -sSL "${target}" | sudo tar -v -C /usr/local -xz
}

# install_docker_ce installs docker-ce
install_docker_ce() {
  sudo apt-get install docker-ce -y

  # fix the damn "Permission denied" issue
  #
  # NOTE: need to log-out and log-in to make new group member into effect.
  sudo gpasswd -a "${USER}" docker
}

# install_dotfiles installs from github.com/0x04C2/dotfiles.
#
# FIXME(0x04C2): if we don't use yes command to do confirm, the scripts will
# raise error "bash: line 3: xit: command not found".
install_dotfiles() {
  git clone https://github.com/0x04C2/dotfiles ~/.dotfiles --depth 1
  cd ~/.dotfiles

  set +o pipefail
  yes | make
  set -o pipefail

  # use ZSH as default shell
  sudo chsh "${USER}" -s "$(which zsh)"
}

main() {
  install_base
  install_golang
  install_docker_ce
  install_dotfiles
}

main
