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
    silversearcher-ag \
    jq \
    \
    zsh \
    vim \
    neovim \
    python3-pip \
    tmux \
    \
    git \
    gcc \
    cmake \
    make \
    \
    lsof \
    \
    linux-tools-common

  sudo pip3 install --upgrade neovim
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

# install_dotfiles installs from github.com/fuweid/dotfiles.
#
# FIXME(fuweid): if we don't use yes command to do confirm, the scripts will
# raise error "bash: line 3: xit: command not found".
install_dotfiles() {
  rm -rf ~/.dotfiles

  git clone https://github.com/fuweid/dotfiles ~/.dotfiles --depth 1
  cd ~/.dotfiles

  set +o pipefail
  yes | make
  set -o pipefail

  # use ZSH as default shell
  sudo chsh "${USER}" -s "$(which zsh)"
}

# install_fzf installs fzf binary.
install_fzf() {
  local target arch

  arch="linux_amd64"

  target="$(curl -sSL https://api.github.com/repos/junegunn/fzf-bin/releases/latest \
    | jq -r ".assets[] | select(.name | test(\"${arch}\")) | .browser_download_url")"

  curl -sSL "${target}" | sudo tar -v -C /usr/local/bin -xz
}

main() {
  install_base
  install_golang
  install_dotfiles
  install_fzf
}

main
