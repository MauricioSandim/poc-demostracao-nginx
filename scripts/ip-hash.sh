#!/bin/bash

echo "========================================="
echo "NGINX POC - IP HASH"
echo "========================================="
echo

for i in {1..15}; do
    curl -s localhost:9753/sticky
    echo
done