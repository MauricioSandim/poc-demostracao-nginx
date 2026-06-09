#!/bin/bash

echo "=== ROUND ROBIN ==="
echo

for i in {1..15}; do
  curl -s localhost:9753/rr
  echo
done