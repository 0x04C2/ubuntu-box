#!/usr/bin/env bash
#
# clone github projects

set -euo pipefail

export GOPATH="${GOPATH:-${HOME}/go}"

# fetch_go_projects clones golang projects.
fetch_go_projects() {
  local projects upstream owner locate pkg_dir common_cmd

  # upstream:owner[@locate]
  # upstream -> like github.com/containerd/containerd
  # owner    -> fuweid/containerd which is part of git ssh URL
  # locate   -> github.com/docker/docker which is used to change the pkg locate
  projects=(
    "github.com/alibaba/pouch:fuweid/pouch"
    "github.com/containerd/containerd:fuweid/containerd"
    "github.com/moby/moby:fuweid/moby@github.com/docker/docker"
    "github.com/moby/buildkit:fuweid/buildkit"
  )

  # FIXME(fuweid): support no upstream type
  for proj in "${projects[@]}" ; do
    upstream="${proj%%:*}"
    owner="${proj##*:}"

    locate=""
    if [[ "${owner##*@}" != "${owner}" ]]; then
      locate="${owner##*@}"
      owner="${owner%%@${locate}}"
    fi

    # for moby
    pkg_dir="${GOPATH}/src/${upstream}"
    if [[ ! -z "${locate}" ]]; then
      pkg_dir="${GOPATH}/src/${locate}"
    fi

    # NOTE(fuweid): remove the existing dir, which only show up testing
    rm -rf "${pkg_dir}"

    # for me
    owner="git@github.com:${owner}"

    git clone -o upstream https://${upstream}.git ${pkg_dir}

    command_cmd="git --git-dir ${pkg_dir}/.git --work-tree ${pkg_dir}"
    ${command_cmd} remote set-url --push upstream no-pushing
    ${command_cmd} remote add me ${owner}
    ${command_cmd} remote -v
  done
}

main() {
  fetch_go_projects
}

main