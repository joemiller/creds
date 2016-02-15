# vim: set ft=sh:
# -*- mode: sh -*-

load helpers

setup() {
  set_test_config
  make_gpg_key
  reset_creds
}

@test "unset subcommand exits with error if no creds store specified" {
  run $CREDS unset
  [ "$status" -eq 1 ]
}

@test "unset subcommand outputs commands to unset the vars in a creds store " {
  run create_creds "test-creds" "KEY=val"
  [ "$status" -eq 0 ]

  run $CREDS unset "test-creds"
  [ "$status" -eq 0 ]
  [[ "$output" == *"unset KEY"* ]]
}
