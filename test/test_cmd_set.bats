# vim: set ft=sh:
# -*- mode: sh -*-

load helpers

setup() {
  set_test_config
  make_gpg_key
  reset_creds
}

@test "set subcommand exits with error if no creds store specified" {
  run $CREDS set
  [ "$status" -eq 1 ]
}

@test "set subcommand outputs contents of creds store" {
  run create_creds "test-creds" "KEY=val"
  [ "$status" -eq 0 ]

  run $CREDS set "test-creds"
  [ "$status" -eq 0 ]
  [[ "$output" == *"export KEY=val"* ]]
}
