#!/bin/bash
set -euo pipefail

MODULE_NAME="credits"
MODULE_DESC="Show project credits"

credits::module_dir() {
  cd "$(dirname "${BASH_SOURCE[0]}")" && pwd
}

credits::root_dir() {
  cd "$(credits::module_dir)/.." && pwd
}

credits::load_common() {
  local root
  root=$(credits::root_dir)
  # shellcheck source=../lib/common.sh
  source "$root/lib/common.sh"
}

credits::run_menu() {
  credits::load_common
  print_section "Project credits"
  cat <<'INFO'
  aut0 mak3r simplifies workstation provisioning and tool management.

  Maintainer : 0n1c0n3
  Original   : mrblackx
  Inspired by contributions from the community.

  Repository : https://github.com/0n1c0n3/aut0_mak3r
INFO
}

run() {
  credits::run_menu "$@"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  run "$@"
fi
