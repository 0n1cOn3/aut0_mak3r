#!/bin/bash
set -euo pipefail

MODULE_NAME="install_tools"
MODULE_DESC="Install tools automatically or manually"

declare -ag INSTALL_TOOLS_ENTRIES=(
  "curl::curl::curl::Transfer data with URLs"
  "git::git::git::Distributed version control"
  "python3::python3::python3::Python language runtime"
  "pip3::python3-pip::pip3::Python package manager"
  "nmap::nmap::nmap::Network exploration tool"
  "htop::htop::htop::Interactive process viewer"
  "net-tools::net-tools::ifconfig::Classic networking tools"
  "speedtest-cli::speedtest-cli::speedtest::Network speed tester"
  "openssh::openssh-client::ssh::OpenSSH client utilities::linux"
  "tmux::tmux::tmux::Terminal multiplexer::linux"
  "vim::vim::vim::Vim text editor::linux"
  "termux-api::termux-api::termux-api::Access Android features via Termux::termux"
  "tsu::tsu::tsu::Switch to superuser within Termux::termux"
  "proot-distro::proot-distro::proot-distro::Manage Linux distributions inside Termux::termux"
  "openssh::openssh::ssh::OpenSSH client utilities::termux"
  "nano::nano::nano::Nano text editor::termux"
  "nodejs-lts::nodejs-lts::node::Long-term support Node.js runtime::termux"
)

declare -Ag INSTALL_TOOLS_UPDATED=()

install_tools::module_dir() {
  cd "$(dirname "${BASH_SOURCE[0]}")" && pwd
}

install_tools::root_dir() {
  cd "$(install_tools::module_dir)/.." && pwd
}

install_tools::load_common() {
  local root
  root=$(install_tools::root_dir)
  # shellcheck source=../lib/common.sh
  source "$root/lib/common.sh"
}

install_tools::entry_field() {
  local entry=$1 field=$2
  local label package check desc platforms
  IFS="::" read -r label package check desc platforms <<<"$entry"
  case $field in
    label) echo "$label" ;;
    package) echo "$package" ;;
    check) echo "$check" ;;
    desc) echo "$desc" ;;
    platforms) echo "$platforms" ;;
  esac
}

install_tools::entry_applies() {
  local entry=$1
  local platforms
  platforms=$(install_tools::entry_field "$entry" platforms)
  if [ -z "$platforms" ]; then
    return 0
  fi
  local platform
  platform=$(install_tools::current_platform)
  local -a tokens=()
  IFS="," read -r -a tokens <<<"$platforms"
  for item in "${tokens[@]}"; do
    if [ "$item" = "$platform" ]; then
      return 0
    fi
  done
  return 1
}

install_tools::is_installed() {
  local entry=$1
  local check
  check=$(install_tools::entry_field "$entry" check)
  if [ -n "$check" ] && command_exists "$check"; then
    return 0
  fi
  local package
  package=$(install_tools::entry_field "$entry" package)
  if command_exists dpkg-query; then
    if dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -q "install ok installed"; then
      return 0
    fi
  fi
  if command_exists rpm; then
    if rpm -q "$package" >/dev/null 2>&1; then
      return 0
    fi
  fi
  if command_exists pacman; then
    if pacman -Q "$package" >/dev/null 2>&1; then
      return 0
    fi
  fi
  if command_exists apk; then
    if apk info "$package" >/dev/null 2>&1; then
      return 0
    fi
  fi
  if command_exists brew; then
    if brew list "$package" >/dev/null 2>&1; then
      return 0
    fi
  fi
  return 1
}

install_tools::current_platform() {
  if command_exists termux-info || command_exists pkg; then
    echo termux
  else
    echo linux
  fi
}

install_tools::detect_manager() {
  if command_exists pkg; then
    echo pkg
  elif command_exists apt-get; then
    echo apt
  elif command_exists dnf; then
    echo dnf
  elif command_exists pacman; then
    echo pacman
  elif command_exists zypper; then
    echo zypper
  elif command_exists apk; then
    echo apk
  elif command_exists brew; then
    echo brew
  else
    return 1
  fi
}

install_tools::run_with_privileges() {
  local manager=$1
  shift
  if [ "$manager" = "brew" ]; then
    "$@"
  elif [ "$EUID" -eq 0 ]; then
    "$@"
  elif command_exists sudo; then
    sudo "$@"
  else
    "$@"
  fi
}

install_tools::refresh_cache() {
  local manager=$1
  if [ "${INSTALL_TOOLS_UPDATED[$manager]:-0}" -eq 1 ]; then
    return 0
  fi
  log_info "Refreshing package cache using $manager"
  case $manager in
    pkg) install_tools::run_with_privileges "$manager" pkg update || install_tools::run_with_privileges "$manager" pkg upgrade -y ;;
    apt) install_tools::run_with_privileges "$manager" apt-get update -y ;;
    dnf) install_tools::run_with_privileges "$manager" dnf makecache ;;
    pacman) install_tools::run_with_privileges "$manager" pacman -Sy --noconfirm ;;
    zypper) install_tools::run_with_privileges "$manager" zypper refresh ;;
    apk) install_tools::run_with_privileges "$manager" apk update ;;
    brew) brew update ;;
    *) return 1 ;;
  esac
  INSTALL_TOOLS_UPDATED[$manager]=1
}

install_tools::install_package() {
  local entry=$1
  local manager
  if ! manager=$(install_tools::detect_manager); then
    log_error "No supported package manager found."
    return 1
  fi

  install_tools::refresh_cache "$manager" || log_warn "Unable to refresh package cache for $manager"
  local package label
  package=$(install_tools::entry_field "$entry" package)
  label=$(install_tools::entry_field "$entry" label)
  log_info "Installing $label ($package) via $manager"
  local success=0
  case $manager in
    pkg) install_tools::run_with_privileges "$manager" pkg install -y "$package" || success=$? ;;
    apt) install_tools::run_with_privileges "$manager" apt-get install -y "$package" || success=$? ;;
    dnf) install_tools::run_with_privileges "$manager" dnf install -y "$package" || success=$? ;;
    pacman) install_tools::run_with_privileges "$manager" pacman -S --noconfirm "$package" || success=$? ;;
    zypper) install_tools::run_with_privileges "$manager" zypper install -y "$package" || success=$? ;;
    apk) install_tools::run_with_privileges "$manager" apk add "$package" || success=$? ;;
    brew) brew install "$package" || success=$? ;;
    *) log_error "Unsupported manager $manager"; return 1 ;;
  esac
  if [ "$success" -eq 0 ]; then
    log_success "$label installed successfully."
  else
    log_error "Failed to install $label (exit code $success)."
  fi
  return "$success"
}

install_tools::list_tools() {
  print_section "Configured tools"
  local entry label desc status
  for entry in "${INSTALL_TOOLS_ENTRIES[@]}"; do
    if ! install_tools::entry_applies "$entry"; then
      continue
    fi
    label=$(install_tools::entry_field "$entry" label)
    desc=$(install_tools::entry_field "$entry" desc)
    if install_tools::is_installed "$entry"; then
      status="installed"
    else
      status="missing"
    fi
    printf "  %-15s %-10s %s\n" "$label" "[$status]" "$desc"
  done
}

install_tools::auto_install() {
  log_info "Starting automatic installation of recommended tools"
  local entry
  for entry in "${INSTALL_TOOLS_ENTRIES[@]}"; do
    if ! install_tools::entry_applies "$entry"; then
      continue
    fi
    if install_tools::is_installed "$entry"; then
      log_success "$(install_tools::entry_field "$entry" label) already installed."
      continue
    fi
    install_tools::install_package "$entry"
  done
}

install_tools::manual_install() {
  local options=()
  local indices=()
  local entry label desc
  local idx
  for idx in "${!INSTALL_TOOLS_ENTRIES[@]}"; do
    entry=${INSTALL_TOOLS_ENTRIES[$idx]}
    if ! install_tools::entry_applies "$entry"; then
      continue
    fi
    label=$(install_tools::entry_field "$entry" label)
    desc=$(install_tools::entry_field "$entry" desc)
    options+=("$label - $desc")
    indices+=("$idx")
  done

  if [ ${#options[@]} -eq 0 ]; then
    log_warn "No tools configured for the current platform"
    return 0
  fi

  while true; do
    local selection
    selection=$(prompt_menu "Select a tool to install:" "${options[@]}") || return 1
    if [ "$selection" -eq -1 ]; then
      break
    fi
    idx=${indices[$selection]}
    entry=${INSTALL_TOOLS_ENTRIES[$idx]}
    if install_tools::is_installed "$entry"; then
      log_success "$(install_tools::entry_field "$entry" label) already installed."
      continue
    fi
    install_tools::install_package "$entry"
  done
}

install_tools::upgrade_system() {
  local manager
  if ! manager=$(install_tools::detect_manager); then
    log_error "No supported package manager found for upgrades."
    return 1
  fi

  log_info "Checking for available upgrades via $manager"
  case $manager in
    pkg)
      install_tools::run_with_privileges "$manager" pkg upgrade -y || return 1
      ;;
    apt)
      install_tools::run_with_privileges "$manager" apt-get update -y
      install_tools::run_with_privileges "$manager" apt-get upgrade -y
      ;;
    dnf)
      install_tools::run_with_privileges "$manager" dnf upgrade --refresh -y
      ;;
    pacman)
      install_tools::run_with_privileges "$manager" pacman -Syu --noconfirm
      ;;
    zypper)
      install_tools::run_with_privileges "$manager" zypper refresh
      install_tools::run_with_privileges "$manager" zypper update -y
      ;;
    apk)
      install_tools::run_with_privileges "$manager" apk update
      install_tools::run_with_privileges "$manager" apk upgrade
      ;;
    brew)
      brew update
      brew upgrade
      ;;
    *)
      log_error "Upgrades are not supported for manager $manager"
      return 1
      ;;
  esac
  log_success "System packages are up to date."
}

install_tools::run_menu() {
  install_tools::load_common
  while true; do
    print_section "Install tools"
    local options=(
      "Automatic installation"
      "Manual installation"
      "List configured tools"
      "Upgrade all packages"
    )
    local selection
    selection=$(prompt_menu "Choose an option:" "${options[@]}") || return 1
    if [ "$selection" -eq -1 ]; then
      break
    fi
    case $selection in
      0) install_tools::auto_install ;;
      1) install_tools::manual_install ;;
      2) install_tools::list_tools ;;
      3) install_tools::upgrade_system || log_error "Failed to upgrade packages." ;;
      *) log_warn "Unknown option selected" ;;
    esac
  done
}

run() {
  install_tools::run_menu "$@"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  run "$@"
fi
