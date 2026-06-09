#!/bin/bash

echo "=== WEIGHTED ROUND ROBIN ==="
echo

TMP_FILE=$(mktemp)

for i in {1..100}; do
  curl -s localhost:9753/weight >> "$TMP_FILE"
  echo >> "$TMP_FILE"
done

cat "$TMP_FILE" \
  | jq -r '.server' \
  | sort \
  | uniq -c \
  | sort -nr

rm "$TMP_FILE"