#!/usr/bin/env bash

INPUT=$(cat)

TEMPLATE=${1:-"{{ key }}={{ value }}"}
TEMPLATE="${TEMPLATE//"{{ key }}"/"\" + .key + \""}"
TEMPLATE="${TEMPLATE//"{{ value }}"/"\"
 + .value + \""}"

TEMPLATE_ENDS_WITH_NEWLINE="false"
if [ "${TEMPLATE: -2}" = '\n' ]; then
  TEMPLATE_ENDS_WITH_NEWLINE="true"
fi

LINES=$(jq -r ". | to_entries | .[] | \"$TEMPLATE\"" 2>/dev/null <<< "$INPUT")
JQ_EXIT_CODE="$?"
[[ "$JQ_EXIT_CODE" != "0" ]] && exit 1

LINE_COUNT=$(echo "$LINES" | wc -l)

OUTPUT=""

readarray -t LINES_ARRAY <<< "$LINES"
for LINE in "${LINES_ARRAY[@]}"; do
  if [ "" != "$LINE" ]; then
    if [ "true" = "$TEMPLATE_ENDS_WITH_NEWLINE" ]; then
      OUTPUT="$OUTPUT$LINE\n"
    else
      if [ "1" != "$LINE_COUNT" ]; then
        LINE="$LINE "
      fi

      OUTPUT="$OUTPUT$LINE"
    fi
  fi
done

echo -e "$OUTPUT"
