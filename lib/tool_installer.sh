#!/bin/bash
# Tool installation helper for aut0 mak3r

# Usage: Source this script and call tool_installer_menu

TOOLS=(
  "nmap"
  "hydra"
  "sqlmap"
  "wireshark"
  "metasploit"
)
# Approximate size in MB for each tool
TOOL_SIZES=(
  50
  15
  20
  300
  200
)

print_tools() {
  local i=1
  for t in "${TOOLS[@]}"; do
    printf "[%d] %s (approx %dMB)\n" "$i" "$t" "${TOOL_SIZES[$((i-1))]}"
    i=$((i+1))
  done
}

check_installed() {
  command -v "$1" >/dev/null 2>&1
}

install_tool() {
  local tool=$1
  case "$tool" in
    nmap|hydra|wireshark)
      sudo apt-get install -y "$tool" ;;
    sqlmap)
      sudo apt-get install -y sqlmap ;;
    metasploit)
      sudo apt-get install -y metasploit-framework ;;
  esac
}

free_space_mb() {
  df -Pm . | awk 'NR==2 {print $4}'
}

required_space() {
  local idx total=0
  for idx in "$@"; do
    total=$(( total + TOOL_SIZES[idx] ))
  done
  echo "$total"
}

# Main menu for selecting tools
# Accepts indices (0-based) of tools to install
run_tool_installer() {
  local selection=("$@")
  local install_list=()
  for idx in "${selection[@]}"; do
    tool="${TOOLS[idx]}"
    if check_installed "$tool"; then
      echo "${tool} already installed. Skipping."
    else
      install_list+=("$tool")
    fi
  done
  if [ ${#install_list[@]} -eq 0 ]; then
    echo "Nothing to install."; return
  fi

  local req_space=$(required_space "${selection[@]}")
  local free_space=$(free_space_mb)
  echo "Selected tools require ~${req_space}MB. Free space: ${free_space}MB."
  if [ "$free_space" -lt "$req_space" ]; then
    echo "Warning: not enough free disk space." >&2
  fi

  for tool in "${install_list[@]}"; do
    read -rp "Install ${tool}? [y/N] " ans
    if [[ $ans =~ ^[Yy]$ ]]; then
      install_tool "$tool" || echo "Failed to install ${tool}" >&2
    fi
  done
}

# Interactive menu
tool_installer_menu() {
  echo "Available tools (${#TOOLS[@]} total):"
  print_tools
  echo "[0] Auto install all"
  echo "[q] Quit"
  read -rp "Select tools (numbers separated by space): " input
  if [[ $input == q ]]; then
    return
  fi
  if [[ $input == 0 ]]; then
    indices=($(seq 0 $((${#TOOLS[@]}-1))))
  else
    indices=()
    for num in $input; do
      if [[ $num =~ ^[0-9]+$ && num -ge 1 && num -le ${#TOOLS[@]} ]]; then
        indices+=( $((num-1)) )
      fi
    done
  fi
  run_tool_installer "${indices[@]}"
}
