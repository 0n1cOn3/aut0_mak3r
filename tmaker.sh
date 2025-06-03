#!/bin/bash
# Dynamic module loader
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=lib/common.sh
source "$ROOT_DIR/lib/common.sh"
MODULE_DIR="$ROOT_DIR/modules"

declare -a MODULE_FILES=()
declare -a MODULE_NAMES=()

load_modules() {
  for f in "$MODULE_DIR"/*.sh; do
    [ -f "$f" ] || continue
    # shellcheck disable=SC1090
    source "$f"
    if [[ -n "${MODULE_NAME:-}" ]]; then
      MODULE_FILES+=("$f")
      MODULE_NAMES+=("$MODULE_NAME")
    else
      name=$(basename "$f" .sh)
      MODULE_FILES+=("$f")
      MODULE_NAMES+=("$name")
    fi
    unset MODULE_NAME MODULE_DESC run
  done
}

print_menu() {
  echo "Available modules:"
  local i=1
  for f in "${MODULE_FILES[@]}"; do
    # shellcheck disable=SC1090
    source "$f"
    local desc="${MODULE_DESC:-}" name="${MODULE_NAME:-$(basename "$f" .sh)}"
    printf "[%d] %s" "$i" "$name"
    if [[ -n "$desc" ]]; then
      printf " - %s" "$desc"
    fi
    printf "\n"
    unset MODULE_NAME MODULE_DESC run
    i=$((i+1))
  done
  echo "[q] Quit"
}

run_module() {
  local idx=$1
  local file="${MODULE_FILES[$idx]}"
  # shellcheck disable=SC1090
  source "$file"
  if declare -f run >/dev/null; then
    run
  else
    bash "$file"
  fi
  unset MODULE_NAME MODULE_DESC run
}

if [ ! -d "$MODULE_DIR" ]; then
  error_exit "Module directory not found: $MODULE_DIR" "$ERR_FILE_NOT_FOUND"
fi

load_modules
if [ ${#MODULE_FILES[@]} -eq 0 ]; then
  error_exit "No modules found in $MODULE_DIR" "$ERR_FILE_NOT_FOUND"
fi

while true; do
  print_menu
  read -rp "Select module: " choice
  if [[ "$choice" == "q" ]]; then
    break
  elif [[ "$choice" =~ ^[0-9]+$ && choice -ge 1 && choice -le ${#MODULE_FILES[@]} ]]; then
    run_module $((choice-1))
  else
    print_error "Invalid option" "$ERR_INVALID_OPTION"
  fi
  echo ""
done
