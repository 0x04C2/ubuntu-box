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
# NOTE: use mirror.tuna.tsinghua.edu.cn 18.04 LTS because of GFW.
setup_mirror_source() {
  sudo mv /etc/apt/sources.list /etc/apt/sources.list.backup

  cat <<-EOF | sudo tee /etc/apt/sources.list
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse
EOF

  sudo apt-get update -y

  # FIXME(fuweid): not sure that why apt-get update will rollback the change
  # of sources.list. need to do that again
  cat <<-EOF | sudo tee /etc/apt/sources.list
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse
EOF
}

# setup_third_party_sources adds third party sources into source.list.d.
setup_third_party_sources() {
  # neovim
  #
  # NOTE: only support versions >= 16.04!!!
  #
  # URL: https://launchpad.net/~neovim-ppa/+archive/ubuntu/stable
  sudo -E add-apt-repository ppa:neovim-ppa/stable -y

  # kubernetes
  #
  # add official GPG key
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
  cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

  # docker-ce
  #
  # add Docker’s official GPG key
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

  # add apt repo
  sudo -E add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

  sudo -E apt-get update -y
}

main() {
  setup_mirror_source
  setup_third_party_sources
}

main
