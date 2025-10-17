#!/bin/bash
# Module metadata for the dynamic loader
MODULE_NAME="misc"
MODULE_DESC="Miscellaneous tools"

run() {
  DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  ROOT="$(dirname "$DIR")"
  source "$ROOT/lib/common.sh"
  [ -f "$ROOT/4ut0m4t10n.sh" ] || error_exit "Main script not found" "$ERR_FILE_NOT_FOUND"
  AUTO_MAK3R_MODULAR=1 bash "$ROOT/4ut0m4t10n.sh" misc
}
