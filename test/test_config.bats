# vim: set ft=sh:
# -*- mode: sh -*-

load helpers

setup() {
  set_test_config
}

@test "calling a subcommand without required configuration vars returns an error" {
  unset CREDS_DIR GPG_KEY
  run $CREDS list
  echo "$output"
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "Missing config var CREDS_DIR." ]
  [ "${lines[1]}" = "Missing config var GPG_KEY." ]
  [ "${lines[2]}" = "Create a ~/.credsrc file with the missing config vars." ]
}

@test "exit with error if unable to find GPG" {
  PATH="/foo" \
    GPG_BIN="/nonexist" \
    run $CREDS list
  echo "$output"
  [ "$status" -eq 1 ]
  [[ "$output" == *"Unable to find"* ]]
}

@test "exit with error if CREDS_DIR does not exist" {
  CREDS_DIR="/nonexist" \
    GPG_KEY="foo" \
    run $CREDS list
  echo "$output"
  [ "$status" -eq 1 ]
  [[ "$output" == "CREDS_DIR '/nonexist' does not exist. Please create this directory." ]]
}

@test "exit with error if GPG_KEY id does not exist" {
  GPG_KEY="no such key" \
    run $CREDS list
  echo "$output"
  [ "$status" -eq 1 ]
  [[ "$output" == "GPG_KEY 'no such key' does not exist." ]]
}
