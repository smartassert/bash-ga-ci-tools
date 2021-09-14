#!/usr/bin/env bats

script_name=$(basename "$BATS_TEST_FILENAME" | sed 's/bats/sh/g')
export script_name

setup() {
  load 'node_modules/bats-support/load'
  load 'node_modules/bats-assert/load'
}

main() {
  bash "${BATS_TEST_DIRNAME}/../src/$script_name"
}

@test "$script_name: no arguments succeeds and outputs nothing" {
  run main

  assert_success
  assert_output ""
}

@test "$script_name: empty json object succeeds and outputs nothing" {
  JSON="{}" \
  run main

  assert_success
  assert_output ""
}

@test "$script_name: empty json array succeeds and outputs nothing" {
  JSON="[]" \
  run main

  assert_success
  assert_output ""
}

@test "$script_name: json object with no empty values succeeds and outputs nothing" {
  JSON='{
  "key1": "value1",
  "key2": "value2",
  "key3": "value3"
}' \
  run main

  assert_success
  assert_output ""
}

@test "$script_name: json object with single empty value fails and outputs relevant key" {
  JSON='{
  "key1": "value1",
  "key2": "",
  "key3": "value3"
}' \
  run main

  assert_failure "1"
  assert_line --index 0 "key2"
}

@test "$script_name: json object with multiple empty value fails and outputs relevant keys" {
  JSON='{
  "key1": "value1",
  "key2": "",
  "key3": ""
}' \
  run main

  assert_failure "1"
  assert_line --index 0 "key2"
  assert_line --index 1 "key3"
}
