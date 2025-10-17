#!/bin/bash
# Backwards compatible entry point that delegates to the modular launcher
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/tmaker.sh" "$@"
