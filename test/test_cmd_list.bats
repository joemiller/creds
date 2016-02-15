# vim: set ft=sh:
# -*- mode: sh -*-

load helpers

setup() {
  set_test_config
  make_gpg_key
  reset_creds
}

@test "list subcommand on an empty CREDS_DIR returns no cred stores" {
  run $CREDS list
  echo "$output"
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" == "Credential storage dir: $CREDS_DIR" ]]
  [ "${#lines[@]}" -eq 1 ]  # single line of output only
}

@test "list subcommand returns a list of creds stores" {
  run create_creds "new-creds-1" "KEY=val"
  [ "$status" -eq 0 ]
  run create_creds "new-creds-2" "KEY=val"
  [ "$status" -eq 0 ]

  run $CREDS list
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "Credential storage dir: $CREDS_DIR" ]
  [ "${lines[1]}" == "- new-creds-1" ]
  [ "${lines[2]}" == "- new-creds-2" ]
}
