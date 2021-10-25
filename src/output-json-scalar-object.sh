#!/usr/bin/env bash

INPUT=$(cat)

TEMPLATE=${1:-"{{ key }}={{ value }}"}
#TEMPLATE=${1:-"-var {{ key }}={{ value }}"}
TEMPLATE="${TEMPLATE//"{{ key }}"/"\" + .key + \""}"
TEMPLATE="${TEMPLATE//"{{ value }}"/"\" + .value + \""}"

SET_OUTPUT_LINES=$(jq -r ". | to_entries | .[] | \"$TEMPLATE\"" 2>/dev/null <<< "$INPUT")
JQ_EXIT_CODE="$?"
[[ "$JQ_EXIT_CODE" != "0" ]] && exit 1

readarray -t SET_OUTPUT_LINES_ARRAY <<< "$SET_OUTPUT_LINES"
for SET_OUTOUT_LINE in "${SET_OUTPUT_LINES_ARRAY[@]}"
do
   echo "$SET_OUTOUT_LINE"
done
