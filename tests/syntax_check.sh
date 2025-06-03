#!/bin/bash
set -e
for f in ../*.sh ../modules/*.sh ../lib/*.sh ../openvpn/openvpn.sh; do
  bash -n "$f"
done
