#!/bin/bash
# install dependencies on circle-ci

set -ex

# install bats
BATS_VERSION="0.4.0"

if bats -v | grep "$BATS_VERSION"; then
  echo "bats $BATS_VERSION already installed."
else
  if [[ ! -e ~/deps/bats_v${BATS_VERSION}.tar.gz ]]; then
    mkdir -p ~/deps
    curl -sSL -o ~/deps/bats_v${BATS_VERSION}.tar.gz https://github.com/sstephenson/bats/archive/v${BATS_VERSION}.tar.gz
  fi
  tar -xf ~/deps/bats_v${BATS_VERSION}.tar.gz
  sudo bats-${BATS_VERSION}/install.sh /usr/local
fi

# install gpg2
if type gpg2; then
  echo "gpg2 already installed."
else
  sudo apt-get update
  sudo apt-get install gnupg2
fi

# install shellcheck (https://github.com/koalaman/shellcheck)
SHELLCHECK_VERSION="0.4.1"
SHELLCHECK_BIN="$HOME/.cabal/bin/shellcheck"

existing_version=$("$SHELLCHECK_BIN" -V | awk '/version:/ {print $2}')
if [ "$existing_version" != "$SHELLCHECK_VERSION" ]; then
	rm -f -- "$SHELLCHECK_BIN"
  echo "Installing ShellCheck $SHELLCHECK_VERSION"
  cabal update --verbose=0
  cabal install --verbose=0 "shellcheck-$SHELLCHECK_VERSION"
else
	echo "Shellcheck $SHELLCHECK_VERSION already installed."
fi
