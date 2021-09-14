#!/usr/bin/env bash

if [ "" = "$JSON" ]; then
  exit 0
fi

KEYS=$(jq "keys[]" <<< "$JSON")
CONTAINS_EMPTY_VALUE=false

while IFS='' read -r KEY; do
  VALUE=$(jq -r ".$KEY" <<< "$JSON")

  if [ "" = "$VALUE" ]; then
    CONTAINS_EMPTY_VALUE=true
    echo "${KEY//\"/}"
  fi
done <<< "$KEYS"

if [ true = $CONTAINS_EMPTY_VALUE ]; then
  exit 1
fi
