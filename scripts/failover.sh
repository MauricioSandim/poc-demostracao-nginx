#!/bin/bash

echo "=== FAILOVER ==="
echo

echo "Parando app2..."
docker stop app2

sleep 3

echo
echo "Executando requisições..."
echo

for i in {1..20}; do
  curl -s localhost:9753/rr
  echo
done