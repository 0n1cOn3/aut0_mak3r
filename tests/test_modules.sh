#!/bin/bash
set -e
output=$(printf 'q\n' | bash ../tmaker.sh)
for m in ../modules/*.sh; do
  name=$(basename "$m" .sh)
  echo "$output" | grep -q "$name"
done
