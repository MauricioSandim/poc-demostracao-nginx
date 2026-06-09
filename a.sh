#!/bin/bash

for i in {1..20}; do
(
  curl -s localhost:9753/lc
  echo
) &
done

wait