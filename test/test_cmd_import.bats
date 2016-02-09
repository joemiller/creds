load helpers

setup() {
  set_test_config
  make_gpg_key
  reset_creds
}

@test "import subcommand exits with error if no file specified" {
  run $CREDS import
  [ "$status" -eq 1 ]
}

@test "import subcommand exits with error if file does not exist" {
  run $CREDS import "/nofile"
  [ "$status" -eq 1 ]
  [[ "$output" == *"File does not exist"* ]]
}

@test "import subcommand" {
  unencrypted_file="$HOME/imported-creds"
  echo "FOO=bar" | tee "$unencrypted_file"

  run $CREDS import "$unencrypted_file"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Encrypting"* ]]

  run $CREDS set "imported-creds"
  [ "$status" -eq 0 ]
  [[ "$output" == *"FOO=bar"* ]]

  # import into an existing creds store should fail
  run $CREDS import "$unencrypted_file"
  [ "$status" -eq 1 ]
  [[ "$output" == *"already exists"* ]]
}
