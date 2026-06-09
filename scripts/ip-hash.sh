#!/bin/bash

echo "=== IP HASH ==="
echo

for i in {1..15}; do
    curl -s localhost:9753/sticky
    echo
done