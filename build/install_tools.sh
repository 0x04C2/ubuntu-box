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
    sudo rm -rf "${GOPATH}"
  fi

  latest_version="$(curl -sSL "https://golang.org/VERSION?m=text")"
  set +u; version="${GO_VESION:-${latest_version}}"; set -u
  target="https://redirector.gvt1.com/edgedl/go/${version}.linux-amd64.tar.gz"

  curl -sSL "${target}" | sudo tar -v -C /usr/local -xz
}

# install_docker_ce installs docker-ce
install_docker_ce() {
  # fix the damn "Permission denied" issue
  #
  # NOTE: need to log-out and log-in to make new group member into effect.
  sudo groupadd docker
  sudo gpasswd -a "${USER}" docker

  sudo apt-get install docker-ce -y
}

main() {
  install_base
  install_golang
  install_docker_ce
}

main
