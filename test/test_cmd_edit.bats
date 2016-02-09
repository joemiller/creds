load helpers

setup() {
  set_test_config
  make_gpg_key
  reset_creds
}

@test "edit subcommand exits with error if no creds store specified" {
  run $CREDS edit
  [ "$status" -eq 1 ]
}

@test "edit subcommand can create a new creds store" {
  run create_creds "new-creds" "KEY=val"
  echo "$output"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Looking for credentials"* ]]
  [[ "$output" == *"Creating new file."* ]]
  [[ "$output" == *"Encrypting..."* ]]
}
