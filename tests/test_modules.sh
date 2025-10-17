#!/bin/bash
set -e
output=$(printf 'q\n' | bash ../tmaker.sh 2>&1)
for m in ../modules/*.sh; do
  name=$(basename "$m" .sh)
  echo "$output" | grep -q "$name"
done
