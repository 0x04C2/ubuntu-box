#!/usr/bin/env bash
#
# ubuntu package management

set -euo pipefail

# all commands are running without interactive
#
# fix "dpkg-reconfigure: unable to re-open stdin: No file or directory" error
export DEBIAN_FRONTEND=noninteractive

# setup_mirror_source uses mirror package source instead of default value.
#
# NOTE: use mirror.tuna.tsinghua.edu.cn 16.04 LTS because of GFW.
setup_mirror_source() {
  sudo cp /etc/apt/sources.list /etc/apt/sources.list.old

  cat <<-EOF | sudo tee /etc/apt/sources.list
# mirror tsinghua.edu.cn
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-security main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-security main restricted universe multiverse
EOF

  # add docker repo source
  sudo apt-get update -y
}

# setup_third_party_sources adds third party sources into source.list.d.
setup_third_party_sources() {
  # add Docker repo source
  # from https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-docker-ce

  # allow apt to use a repository over HTTPS
  sudo apt-get install -y \
    curl \
    ca-certificates \
    apt-transport-https \
    software-properties-common \
    --no-install-recommends

  # add Docker’s official GPG key
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

  cat <<-EOF | sudo tee /etc/apt/sources.list.d/docker.list
# docker-ce
deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable
EOF

  # add neovim repo source
  #
  # NOTE: only support versions >= 16.04!!!
  sudo add-apt-repository ppa:neovim-ppa/stable -y

  # add golang repo source
  sudo add-apt-repository ppa:gophers/archive -y

  sudo apt-get update -y
}

main() {
  setup_mirror_source
  setup_third_party_sources
}

main
