#!/bin/bash
set -euo pipefail

MODULE_NAME="cli_tools"
MODULE_DESC="Command line utilities"

cli_tools::module_dir() {
  cd "$(dirname "${BASH_SOURCE[0]}")" && pwd
}

cli_tools::root_dir() {
  cd "$(cli_tools::module_dir)/.." && pwd
}

cli_tools::load_common() {
  local root
  root=$(cli_tools::root_dir)
  # shellcheck source=../lib/common.sh
  source "$root/lib/common.sh"
}

cli_tools::delete_history() {
  local history_file="${HISTFILE:-$HOME/.bash_history}"
  if [ ! -e "$history_file" ]; then
    log_warn "No history file found at $history_file"
    return 0
  fi

  if prompt_confirm "Clear shell history stored in $history_file?" n; then
    if : >"$history_file"; then
      log_success "Cleared history file $history_file"
    else
      log_error "Unable to clear history file $history_file"
    fi
  else
    log_info "Skipped history cleanup"
  fi
}

cli_tools::list_local_ips() {
  print_section "Local network interfaces"
  if command_exists ip; then
    ip -o addr show | while read -r _ dev fam addr _; do
      printf "  %-10s %s %s\n" "$dev" "$fam" "$addr"
    done
  elif command_exists ifconfig; then
    ifconfig | sed 's/^/  /'
  else
    log_warn "Neither 'ip' nor 'ifconfig' is available."
  fi
}

cli_tools::show_public_ips() {
  print_section "Public IP discovery"
  local services=("https://ifconfig.me" "https://icanhazip.com")
  local fetched=0
  for service in "${services[@]}"; do
    if command_exists curl; then
      local ip
      ip=$(curl -fsS "$service" || true)
      if [ -n "$ip" ]; then
        printf "  %-25s %s\n" "$service" "$ip"
        fetched=1
      fi
    fi
  done
  if [ "$fetched" -eq 0 ]; then
    log_warn "Unable to reach public IP services."
  fi
}

cli_tools::list_open_ports() {
  print_section "Listening services"
  if command_exists ss; then
    ss -tulpen || log_warn "Failed to execute 'ss'."
  elif command_exists netstat; then
    netstat -tulpen || log_warn "Failed to execute 'netstat'."
  else
    log_warn "Neither 'ss' nor 'netstat' is available."
  fi
}

cli_tools::ping_host() {
  read -r -p "Enter host to ping: " host
  if [ -z "$host" ]; then
    log_warn "No host provided."
    return 0
  fi

  if command_exists ping; then
    if ! ping -c 4 "$host"; then
      log_warn "Ping command reported an error."
    fi
  else
    log_error "'ping' command is not available."
  fi
}

cli_tools::disk_usage() {
  print_section "Disk usage"
  if command_exists df; then
    df -h || log_warn "Unable to gather disk usage information."
  else
    log_warn "'df' command is not available."
  fi
}

cli_tools::system_summary() {
  print_section "System summary"
  echo "  Hostname : $(hostname 2>/dev/null || echo "unknown")"
  echo "  Kernel   : $(uname -srmo 2>/dev/null || echo "unknown")"
  if command_exists uptime; then
    echo "  Uptime   : $(uptime -p 2>/dev/null || uptime 2>/dev/null)"
  fi
  if command_exists who; then
    echo "  Users    :"
    who || true
  fi
}

cli_tools::traceroute_host() {
  read -r -p "Enter host to traceroute: " host
  if [ -z "$host" ]; then
    log_warn "No host provided."
    return 0
  fi

  if command_exists traceroute; then
    traceroute "$host" || log_warn "Traceroute command reported an error."
  elif command_exists tracepath; then
    tracepath "$host" || log_warn "Tracepath command reported an error."
  else
    log_error "Neither 'traceroute' nor 'tracepath' is available."
  fi
}

cli_tools::dns_lookup() {
  read -r -p "Enter domain to query: " domain
  if [ -z "$domain" ]; then
    log_warn "No domain provided."
    return 0
  fi

  if command_exists dig; then
    dig "$domain" +short || log_warn "'dig' reported an error."
  elif command_exists nslookup; then
    nslookup "$domain" || log_warn "'nslookup' reported an error."
  else
    log_error "Neither 'dig' nor 'nslookup' is available."
  fi
}

cli_tools::whois_lookup() {
  read -r -p "Enter domain or IP for WHOIS lookup: " target
  if [ -z "$target" ]; then
    log_warn "No target provided."
    return 0
  fi

  if command_exists whois; then
    whois "$target" || log_warn "'whois' reported an error."
  else
    log_error "'whois' command is not available."
  fi
}

cli_tools::speed_test() {
  print_section "Speed test"
  if command_exists speedtest-cli; then
    speedtest-cli || log_warn "Speed test failed."
  else
    log_error "'speedtest-cli' is not available."
  fi
}

cli_tools::scan_network() {
  read -r -p "Enter network/CIDR to scan (e.g. 192.168.1.0/24): " network
  if [ -z "$network" ]; then
    log_warn "No network provided."
    return 0
  fi

  if command_exists nmap; then
    nmap -sn "$network" || log_warn "Network scan encountered an error."
  else
    log_error "'nmap' command is not available."
  fi
}

cli_tools::tail_log() {
  read -r -p "Enter log file path: " logfile
  if [ -z "$logfile" ]; then
    log_warn "No log file provided."
    return 0
  fi
  if [ ! -f "$logfile" ]; then
    log_error "Log file not found: $logfile"
    return 0
  fi

  ${PAGER:-tail} -n 50 "$logfile" || log_warn "Unable to read log file."
}

cli_tools::monitor_resources() {
  if command_exists htop; then
    htop || log_warn "'htop' exited with an error."
  else
    log_info "Falling back to 'top' (press q to quit)."
    if command_exists top; then
      top || log_warn "'top' exited with an error."
    else
      log_error "Neither 'htop' nor 'top' is available."
    fi
  fi
}

cli_tools::run_menu() {
  cli_tools::load_common
  while true; do
    print_section "Command line utilities"
    local options=(
      "Delete shell history"
      "List local IP addresses"
      "Display public IP addresses"
      "Show listening/open ports"
      "Ping a host"
      "Show disk usage"
      "Show system summary"
      "Traceroute a host"
      "DNS lookup"
      "WHOIS lookup"
      "Speed test"
      "Scan local network for hosts"
      "Tail a log file"
      "Monitor system resources"
    )
    local selection
    selection=$(prompt_menu "Choose an action:" "${options[@]}") || return 1
    if [ "$selection" -eq -1 ]; then
      break
    fi
    case $selection in
      0) cli_tools::delete_history ;;
      1) cli_tools::list_local_ips ;;
      2) cli_tools::show_public_ips ;;
      3) cli_tools::list_open_ports ;;
      4) cli_tools::ping_host ;;
      5) cli_tools::disk_usage ;;
      6) cli_tools::system_summary ;;
      7) cli_tools::traceroute_host ;;
      8) cli_tools::dns_lookup ;;
      9) cli_tools::whois_lookup ;;
      10) cli_tools::speed_test ;;
      11) cli_tools::scan_network ;;
      12) cli_tools::tail_log ;;
      13) cli_tools::monitor_resources ;;
      *) log_warn "Invalid option selected" ;;
    esac
  done
}

run() {
  cli_tools::run_menu "$@"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  run "$@"
fi
