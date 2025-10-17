#!/bin/bash
# Shared utility functions and variables

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$DIR/errorcodes.sh" ]; then
  # shellcheck disable=SC1091
  if ! declare -p ERR_SUCCESS >/dev/null 2>&1; then
    source "$DIR/errorcodes.sh"
  fi
fi

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
BOLD="\e[1m"
NORMAL="\e[0m"

pause() { read -r -p "$*"; }

run_spinner() {
  for _ in {1..3}; do
    echo -n "."; sleep 0.8
  done
}

print_error() {
  local msg=$1 code=${2:-$ERR_GENERAL}
  echo -e "${RED}[${code}] ${YELLOW}${msg}" >&2
}

error_exit() {
  local msg=$1 code=${2:-$ERR_GENERAL}
  print_error "$msg" "$code"
  exit "$code"
}
