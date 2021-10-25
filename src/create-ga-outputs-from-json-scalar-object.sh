#!/usr/bin/env bash

CURRENT_DIRECTORY=$(dirname "$0")

"$CURRENT_DIRECTORY"/output-json-scalar-object.sh "::set-output name={{ key }}::{{ value }}\n"
