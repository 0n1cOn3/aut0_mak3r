#!/bin/bash
# Modular launcher for aut0 mak3r
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
MODULE_DIR="$ROOT_DIR/modules"
# shellcheck source=lib/common.sh
source "$ROOT_DIR/lib/common.sh"

load_module_files() {
  MODULE_FILES=()
  while IFS= read -r file; do
    MODULE_FILES+=("$file")
  done < <(find "$MODULE_DIR" -maxdepth 1 -type f -name '*.sh' | sort)
}

module_metadata() {
  local file=$1 var=$2
  bash -c "source \"$file\" >/dev/null 2>&1; echo \"\${$var:-}\""
}

module_name() {
  local file=$1 name
  name=$(module_metadata "$file" MODULE_NAME)
  if [ -z "$name" ]; then
    name=$(basename "$file" .sh)
  fi
  echo "$name"
}

module_desc() {
  local file=$1
  module_metadata "$file" MODULE_DESC
}

run_module() {
  local file=$1
  bash "$file"
}

main_menu() {
  if [ ${#MODULE_FILES[@]} -eq 0 ]; then
    error_exit "No modules found in $MODULE_DIR" "${ERR_FILE_NOT_FOUND:-1}"
  fi

  while true; do
    print_section "Available modules"
    local options=()
    for file in "${MODULE_FILES[@]}"; do
      local name desc label
      name=$(module_name "$file")
      desc=$(module_desc "$file")
      label="$name"
      if [ -n "$desc" ]; then
        label="$label - $desc"
      fi
      options+=("$label")
    done

    local selection
    selection=$(prompt_menu "Select a module:" "${options[@]}") || return 1
    if [ "$selection" -eq -1 ]; then
      break
    fi

    local index=$selection
    if (( index >= 0 && index < ${#MODULE_FILES[@]} )); then
      run_module "${MODULE_FILES[$index]}"
    else
      log_warn "Invalid module index $index"
    fi
  done
}

if [ ! -d "$MODULE_DIR" ]; then
  error_exit "Module directory not found: $MODULE_DIR" "${ERR_FILE_NOT_FOUND:-1}"
fi

declare -a MODULE_FILES
load_module_files
main_menu
