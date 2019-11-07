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
# TODO(fuweid): use mirror.tuna.tsinghua.edu.cn 19.10 because of GFW.
setup_mirror_source() {
  return

  sudo cp /etc/apt/sources.list /etc/apt/sources.list.old

  cat <<-EOF | sudo tee /etc/apt/sources.list
EOF

  # add docker repo source
  sudo apt-get update -y
}

# setup_third_party_sources adds third party sources into source.list.d.
setup_third_party_sources() {
  # add neovim repo source
  #
  # NOTE: only support versions >= 16.04!!!
  sudo add-apt-repository ppa:neovim-ppa/stable -y

  sudo apt-get update -y
}

main() {
  setup_third_party_sources
}

main
