#!/usr/bin/env bats

script_name=$(basename "$BATS_TEST_FILENAME" | sed 's/bats/sh/g')
export script_name

setup() {
  load 'node_modules/bats-support/load'
  load 'node_modules/bats-assert/load'
  load 'node_modules/bats-file/load'
}

main() {
  bash "${BATS_TEST_DIRNAME}/../src/$script_name"
}

@test "$script_name: empty REPO fails" {
  export VERSION="master"
  export FILE_PATH="example.txt"

  run main

  assert_failure "3"
}

@test "$script_name: empty VERSION fails" {
  export REPO="smartassert/bash-ga-ci-tools"
  export FILE_PATH="example.txt"

  run main

  assert_failure "4"
}

@test "$script_name: empty FILE_PATH fails" {
  export REPO="smartassert/bash-ga-ci-tools"
  export VERSION="master"

  run main

  assert_failure "5"
}

@test "$script_name: remote response is 404" {
  export REPO="smartassert/bash-ga-ci-tools"
  export VERSION="master"
  export FILE_PATH="example.txt"

  function curl() {
    echo "404"
  }

  export -f curl

  run main

  assert_failure "6"
  assert_output "URL: https://raw.githubusercontent.com/smartassert/bash-ga-ci-tools/master/example.txt
Status code: 404"
}

@test "$script_name: request is successful" {
  export REPO="smartassert/bash-ga-ci-tools"
  export VERSION="master"
  export FILE_PATH="example.txt"

  export FILE_CONTENT="file content line 1
file content line 2"

  function curl() {
    if [ "$5" != "" ]; then
      echo "200"
    else
      echo "$FILE_CONTENT"
    fi
  }

  export -f curl

  rm -f "$FILE_PATH"
  assert_file_not_exist "$FILE_PATH"

  run main

  READ_FILE_CONTENT=$(<$FILE_PATH)
  echo "$READ_FILE_CONTENT"

  assert_success
  assert_file_exist "$FILE_PATH"
  assert_equal "$FILE_CONTENT" "$READ_FILE_CONTENT"

  rm -f "$FILE_PATH"
  assert_file_not_exist "$FILE_PATH"
}
