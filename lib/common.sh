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
  local msg=$1 code=${2:-${ERR_GENERAL:-1}}
  echo -e "${RED}[${code}] ${YELLOW}${msg}${NORMAL}" >&2
}

error_exit() {
  local msg=$1 code=${2:-${ERR_GENERAL:-1}}
  print_error "$msg" "$code"
  exit "$code"
}

log_info() {
  echo -e "${CYAN}[i]${NORMAL} $*"
}

log_success() {
  echo -e "${GREEN}[✓]${NORMAL} $*"
}

log_warn() {
  echo -e "${YELLOW}[!]${NORMAL} $*"
}

log_error() {
  echo -e "${RED}[x]${NORMAL} $*"
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

prompt_confirm() {
  local prompt=${1:-"Proceed?"}
  local default=${2:-n}
  local hint="[y/N]"
  case $default in
    y|Y) hint="[Y/n]" ;;
  esac
  while true; do
    read -r -p "$prompt $hint " reply
    reply=${reply:-$default}
    case $reply in
      y|Y) return 0 ;;
      n|N) return 1 ;;
      *) log_warn "Please respond with 'y' or 'n'." ;;
    esac
  done
}

prompt_menu() {
  local prompt=$1
  shift
  local options=("$@")
  if [ ${#options[@]} -eq 0 ]; then
    log_error "prompt_menu called without options"
    return 1
  fi
  while true; do
    >&2 echo ""
    for i in "${!options[@]}"; do
      >&2 printf "  %2d) %s\n" "$((i+1))" "${options[$i]}"
    done
    >&2 echo "  q) Quit"
    >&2 printf "%s " "$prompt"
    read -r choice
    if [[ $choice == "q" ]]; then
      echo -1
      return 0
    elif [[ $choice =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#options[@]} )); then
      echo $((choice-1))
      return 0
    else
      log_warn "Invalid option: $choice"
    fi
  done
}

print_section() {
  local title=$1
  echo ""
  echo -e "${BOLD}${title}${NORMAL}"
  printf '%*s\n' "${#title}" '' | tr ' ' '-'
}
