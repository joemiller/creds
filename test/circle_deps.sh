#!/bin/bash
# install dependencies on circle-ci

set -ex

# install bats
bats_version="0.4.0"

if bats -v | grep "$bats_version"; then
  echo "bats $bats_version already installed."
else
  if [[ ! -e ~/deps/bats_v${bats_version}.tar.gz ]]; then
    mkdir -p ~/deps
    curl -sSL -o ~/deps/bats_v${bats_version}.tar.gz https://github.com/sstephenson/bats/archive/v${bats_version}.tar.gz
  fi
  tar -xf ~/deps/bats_v${bats_version}.tar.gz
  sudo bats-${bats_version}/install.sh /usr/local
fi

# install gpg2
if type -P gpg2; then
  echo "gpg2 already installed."
else
  sudo apt-get update
  sudo apt-get install gnupg2
fi
