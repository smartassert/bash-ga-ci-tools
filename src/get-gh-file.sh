#!/usr/bin/env bash

EXIT_CODE_REPO_EMPTY=3
EXIT_CODE_VERSION_EMPTY=4
EXIT_CODE_FILE_PATH_EMPTY=5
EXIT_CODE_REMOTE_FILE_NOT_FOUND=6

if [ -z "$REPO" ]; then
  exit $EXIT_CODE_REPO_EMPTY
fi

if [ -z "$VERSION" ]; then
  exit "$EXIT_CODE_VERSION_EMPTY"
fi

if [ -z "$FILE_PATH" ]; then
  exit "$EXIT_CODE_FILE_PATH_EMPTY"
fi

URL="https://raw.githubusercontent.com/$REPO/$VERSION/$FILE_PATH"
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")

if [ "200" != "$STATUS_CODE" ]; then
  echo "URL: $URL"
  echo "Status code: $STATUS_CODE"
  exit "$EXIT_CODE_REMOTE_FILE_NOT_FOUND"
fi

curl -s "$URL" > "$FILE_PATH"

exit 0
