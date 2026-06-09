#!/bin/bash

echo "=== RECOVERY ==="
echo

echo "Subindo app2..."
docker start app2

sleep 5

echo
echo "Executando requisições..."
echo

for i in {1..20}; do
  curl -s localhost:9753/rr
  echo
done