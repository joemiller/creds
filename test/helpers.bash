#!/usr/bin/env bash

set_test_config() {
  CREDS='./creds'
  export CREDS

  HOME="$BATS_TMPDIR"
  export HOME

  GNUPGHOME="$HOME/gpghome"
  export GNUPGHOME
  mkdir -p "$GNUPGHOME"
  chmod 700 "$GNUPGHOME"

  CREDS_DIR="$HOME/creds"
  export CREDS_DIR
  mkdir -p "$CREDS_DIR"

  GPG_KEY="test-key"
  export GPG_KEY
}

make_gpg_key() {
  rm -rf -- "${GNUPGHOME:?}/"*
  # remove /dev/null redirection if you suspect errors during gpg key creation when
  # the tests are run, otherwise it clutters the output of the commands under test.
  out=$(gpg2 --batch --quiet --gen-key --debug-quick-random ./test/gpg-keygen.conf 2>&1)
  if [ $? -gt 0 ]; then
    echo "gpg2 returned error:"
    echo "$out"
  fi
}

reset_creds() {
  rm -f -- "${CREDS_DIR:?}"/*.gpg
}

create_creds() {
  local creds_store=$1
  local contents=$2
  rm -f -- "$CREDS_DIR/${creds_store}.gpg"
  tmpfile=$(mktemp)
  printf "%s\n" "$contents" >"$tmpfile"
  export EDITOR="mv $tmpfile "
  $CREDS edit "$creds_store"
}
