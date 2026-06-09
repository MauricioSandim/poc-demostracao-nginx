#!/bin/bash

echo "=== LEAST CONNECTIONS ==="
echo

for i in {1..20}; do
(
  curl -s localhost:9753/lc
  echo
) &
  sleep 0.3
done

wait

echo
echo "Teste concluído."