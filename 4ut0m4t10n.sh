#!/bin/bash

# __author__      : mrblackx
# __description__ : configuration tool
# __time__        : 5 months
# __version__     : v0.3f
# __maintainer__  : 0n1c0n3

set -euo pipefail
trap 'err_report $?' ERR


path=$(pwd)
backup_window_size="printf '\e[8;24;80t'"
ipaddr="$(curl -s ifconfig.me)"
ipaddr2="$(curl -s icanhazip.com)"
host="$(uname -n)"
version="0.3f"
l="."

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "$DIR/lib/common.sh"
RESTORE="\e[39"


#printf '\e[8;37;100t'

# Functions

update(){
    echo -e "${MAGENTA}[*] ${BLUE}Checking for updates..."
    echo ""
    sleep 0.5
    local output
    if output=$(git pull --quiet 2>&1); then
        if [[ $output == *"Already up to date."* ]]; then
            echo -e "${GREEN}[i] ${BLUE}Already on the latest version :-)"
        else
            echo -e "${MAGENTA}[*] ${BLUE}Tool updated to version $version."
        fi
    else
        echo -e "${RED}[!] ${YELLOW}Update failed" >&2
    fi
}


main() {
	o="$(uname -o)"
	if [ $o == "Android" ]
	then
		cd $HOME/aut0_mak3r
		[ -z "$AUTO_MAK3R_MODULAR" ] && bash 4ut0m4t10n.sh
	else
		tmaker
	fi
}
run(){
        run_spinner
}
err_report() {
        local code=$1
        print_error "An unexpected error occurred." "$code"
        echo -e "${YELLOW}Please report it at https://github.com/0n1c0n3/aut0_mak3r/issues (originally by rebl0x3r)" >&2
        exit "$code"
}

err_solver() {

        clear
        echo -e "${RED}[!] ${YELLOW}Wrong command..."
        sleep 2
        clear
        [ -z "$AUTO_MAK3R_MODULAR" ] && bash 4ut0m4t10n.sh
}

run_as_root() {
        if command -v sudo >/dev/null 2>&1 && [[ $EUID -ne 0 ]]; then
                sudo "$@"
        else
                "$@"
        fi
}

install_apt_key() {
        local key_url=$1
        local destination=$2
        local temp_key

        temp_key=$(mktemp)
        if ! curl -fsSL "$key_url" -o "$temp_key"; then
                rm -f "$temp_key"
                print_error "Failed to download key from ${key_url}"
                return 1
        fi

        mkdir -p "$(dirname "$destination")"
        if command -v gpg >/dev/null 2>&1; then
                local temp_gpg
                temp_gpg=$(mktemp)
                if gpg --dearmor <"$temp_key" >"$temp_gpg" 2>/dev/null; then
                        run_as_root install -m 644 "$temp_gpg" "$destination"
                        rm -f "$temp_gpg"
                else
                        print_error "Failed to convert key for ${destination}"
                        rm -f "$temp_gpg"
                fi
        else
                run_as_root install -m 644 "$temp_key" "$destination"
        fi

        rm -f "$temp_key"
}

get_release_codename() {
        if command -v lsb_release >/dev/null 2>&1; then
                lsb_release -sc
        elif [[ -f /etc/os-release ]]; then
                # shellcheck disable=SC1091
                . /etc/os-release
                echo "${VERSION_CODENAME:-${UBUNTU_CODENAME:-stable}}"
        else
                echo "stable"
        fi
}

write_repo_entry() {
        local entry=$1
        local file_path=$2
        printf "%s\n" "$entry" | run_as_root tee "$file_path" >/dev/null
}

download_latest_freevpn_bundle() {
        local destination_dir=$1
        local base_url="https://freevpnme.b-cdn.net/FreeVPN.me-OpenVPN-Bundle"
        local bundle_url=""

        for offset in $(seq 0 59); do
                local label
                label=$(date -d "-${offset} month" '+%B-%Y') || continue
                local url="${base_url}-${label}.zip"
                if curl -sfI "$url" >/dev/null 2>&1; then
                        bundle_url="$url"
                        break
                fi
        done

        if [[ -z "$bundle_url" ]]; then
                print_error "Unable to locate the latest FreeVPN bundle."
                return 1
        fi

        mkdir -p "$destination_dir"
        local bundle_name
        bundle_name=$(basename "$bundle_url")
        if curl -fLo "$destination_dir/$bundle_name" "$bundle_url"; then
                echo "$bundle_name"
        else
                print_error "Failed to download ${bundle_url}."
                return 1
        fi
}

ensure_snapd_ready() {
        if command -v snap >/dev/null 2>&1; then
                return 0
        fi

        local snap_log="${path}/logs/snap/setup.log"
        mkdir -p "$(dirname "$snap_log")"
        echo -e "${RED}[*] ${YELLOW}Preparing snap daemon..."
        if run_as_root apt-get update >>"$snap_log" 2>&1 && run_as_root apt-get install -y snapd >>"$snap_log" 2>&1; then
                if command -v systemctl >/dev/null 2>&1; then
                        run_as_root systemctl enable --now snapd.socket >>"$snap_log" 2>&1 || true
                        run_as_root systemctl start snapd.service >>"$snap_log" 2>&1 || true
                fi
                if [[ ! -d /snap ]]; then
                        run_as_root ln -s /var/lib/snapd/snap /snap 2>/dev/null || true
                fi
                return 0
        fi

        print_error "Failed to configure snapd. Check ${snap_log} for details."
        return 1
}

github_latest_asset() {
        local repository=$1
        local pattern=$2
        python3 - "$repository" "$pattern" <<'PY'
import json
import re
import sys
import urllib.request

repo = sys.argv[1]
pattern = re.compile(sys.argv[2])
url = f"https://api.github.com/repos/{repo}/releases/latest"

with urllib.request.urlopen(url) as response:
    data = json.load(response)

for asset in data.get("assets", []):
    if pattern.search(asset["name"]):
        print(asset["browser_download_url"])
        break
PY
}

log_and_install() {
        local command_name=$1
        local package_names=$2
        local log_file=$3
        local display_name=${4:-$command_name}

        printf "${CYAN}%s... -> " "$display_name"
        sleep 0.3
        if command -v "$command_name" >/dev/null 2>&1; then
                echo -e "${GREEN}Installed [✓]"
                return 0
        fi

        echo -e "${RED}Not installed [✗]"
        mkdir -p "$(dirname "$log_file")"
        if run_as_root apt-get install -y $package_names >"$log_file" 2>&1; then
                echo -e "${GREEN}[i] ${BLUE}Successfully installed ${display_name}."
        else
                print_error "Failed to install ${display_name}. Check ${log_file} for details."
        fi
}

package_installer() {

        printf '\n'
        log_and_install "tilix" "tilix" "${path}/logs/apt/tilix.log" "Tilix"

        printf '\n'
        if ! command -v python3 >/dev/null 2>&1; then
                log_and_install "python3" "python3" "${path}/logs/apt/python3.log" "Python 3"
        fi
        if ! command -v python >/dev/null 2>&1; then
                log_and_install "python" "python-is-python3" "${path}/logs/apt/python.log" "Python"
        else
                echo -e "${GREEN}Python... -> Installed [✓]"
        fi

        printf '\n'
        log_and_install "nano" "nano" "${path}/logs/apt/nano.log" "Nano"

        printf '\n'
        log_and_install "figlet" "figlet" "${path}/logs/apt/figlet.log" "Figlet"

        printf '\n'
        log_and_install "speedtest" "speedtest-cli" "${path}/logs/apt/speedtest-cli.log" "Speedtest"

}

ensure_launcher() {
        local target_path=$1
        local requires_privilege=${2:-0}

        if [[ $requires_privilege -eq 1 ]]; then
                run_as_root rm -f "$target_path" 2>/dev/null || true
                run_as_root cp -f "$DIR/4ut0m4t10n.sh" "$target_path"
                run_as_root chmod +x "$target_path"
        else
                rm -f "$target_path" 2>/dev/null || true
                cp -f "$DIR/4ut0m4t10n.sh" "$target_path"
                chmod +x "$target_path"
        fi
}

command_check() {
        local os_name=$(uname -s)
        echo -e "${RED}[*] ${YELLOW}Checking if tool callable...\n"

        case "$os_name" in
                Linux)
                        local linux_target="/usr/bin/tmaker"
                        if [[ -f "$linux_target" ]]; then
                                echo -e "${YELLOW}[~] ${BLUE}Refreshing existing launcher entry..."
                        else
                                echo -e "${RED}[*] ${YELLOW}Tool is not callable, adding it...."
                        fi
                        ensure_launcher "$linux_target" 1
                        ;;
                Android)
                        local termux_path="/data/data/com.termux/files/usr/bin/tmaker"
                        if [[ -f "$termux_path" ]]; then
                                echo -e "${YELLOW}[~] ${BLUE}Refreshing existing launcher entry..."
                        else
                                echo -e "${RED}[*] ${YELLOW}Tool is not callable, adding it...."
                        fi
                        ensure_launcher "$termux_path" 0
                        ;;
                *)
                        echo -e "${YELLOW}[!] Unsupported platform: ${os_name}."
                        return
                        ;;
        esac

        echo -e "${GREEN}[*] ${YELLOW}You can call the tool by: ${BLUE}tmaker"
}

pause() {
	read -p "$*"
}

full_config(){
	clear
	figlet -f slant "FullConfig"
	echo -e "

${RED}[1] ${YELLOW}Edit Sources
${RED}[2] ${YELLOW}Restore Sources
${RED}[3] ${YELLOW}Package installation
${RED}[4] ${YELLOW}Kali Packages
${RED}[5] ${YELLOW}Custom Update
${RED}[6] ${YELLOW}Install Tor Browser
${RED}[7] ${YELLOW}Change DNS
${RED}[8] ${YELLOW}Generate Strong Password
${RED}[9] ${YELLOW}Setup OpenVPN account
${RED}[10] ${YELLOW}Install Editor
${RED}[11] ${YELLOW}Install Burner
${RED}[12] ${YELLOW}Check Internet Connection

${RED}[back] ${YELLOW}Back To Main Menu
	"

	sources(){
		cd openvpn
		chmod a+x openvpn.sh
		cd ..
		clear
		echo -e "${GREEN}Checking root..."
		echo ''
		sleep 1
		if [ "$EUID" -ne 0 ]
		then
			echo -e "${RED}[✗] No root detected >:("
		else
			echo -e "${GREEN}[✓] Root Access :)"
		fi
		clear
		sleep 1.5
		pause 'Press [Enter] to Start'
		clear
		echo -ne $YELLOW"[!] Starting package checking dependencies";run;printf "\n\n"
		sleep 0.5
		package_installer
		echo -ne "${CYAN}[!] Configuring your source list"; run;printf "\n\n"
		sleep 0.7
		sudo mv /etc/apt/sources.list backup/
		sudo touch /etc/apt/sources.list
                printf "deb https://http.kali.org/kali kali-rolling main non-free contrib\ndeb-src https://http.kali.org/kali kali-rolling main non-free contrib\n" >> /etc/apt/sources.list
		cound_words=$(wc -l /etc/apt/sources.list | cut -d\  -f 1)
		sleep 1
		echo -e $BLUE"Added ${RED}$cound_words ${BLUE}lines to the sources.list file."
		clear
		pause 'Press [Enter] to continue...'
		echo -e $BOLD ""
		echo -e $YELLOW ""
		clear
		read -p "[*] Do you want to see the new added lines[y/N]? " sl
		if [[ $sl == "y" || $sl == "Y" ]]
		then
			cd lib
			tilix -e bash source.sh
			sleep 0.5
			killp=$(ps aux | grep xterm | head -1  | awk '{print $2}')
			kill -9 $killp 2>/dev/null
			cd ..
		else
			echo ""
			echo -ne "${RED}[skiping] ${YELLOW}Ignoring new entries at ${RED}/etc/apt/sources.list";run;printf "\n\n"
			sleep 1
		fi
		clear
                echo -e "$BOLD"
                echo -e "${RED}[!] Importing kali.org archive key:"
                local key_destination="/etc/apt/trusted.gpg.d/kali-archive-keyring.gpg"
                local key_log="${path}/logs/apt/kali-archive-key.log"
                mkdir -p "$(dirname "$key_log")"
                if install_apt_key "https://archive.kali.org/archive-key.asc" "$key_destination" >"$key_log" 2>&1; then
                        echo -e "${GREEN}[i] ${BLUE}Done."
                else
                        print_error "Failed to install Kali archive key. Check ${key_log} for more information."
                fi
                pause 'Press [Enter] go back to menu'
                full_config
        }

	drivers(){
		read -p "[*] Do you want install certain drivers (nexten, realtek, misc-nonfree)[y/N]?: " drv
		if [[ $drv == "y" || $drv == "Y" ]]
		then
			clear
			echo -e "[~] ${GREEN}Installing new driver packages, get something to drink and relax."
			sleep 0.5
		    sudo apt-get install firmware-misc-nonfree firmware-netxen firmware-realtek -y
			cd lib;sudo cp -R *.bin /lib/firmware/i915;cd ..
			clear
			echo -e $GREEN "[✓] ${CYAN}Packages has been successfully installed."
			echo -e "${GREEN}[i] ${BLUE}Done."
			pause 'Press [Enter] back to the menu'
			sleep 0.7
			full_config
		fi
	}

	packages(){
		echo -e "${YELLOW}[!] Updating system."
		#sudo apt-key adv --keyserver hkp://pool.sks-keyservers.net:80 --recv-keys 74A941BA219EC810
		sudo apt update; sudo apt upgrade -y; sudo apt full-upgrade -y; echo ""
		echo -e "${GREEN}[✓] ${CYAN}Your system has been updated."
		pause 'Press [Enter] to continue....'
		sleep 1
		clear
		echo -e $CYAN ""
		echo -e $BOLD ""
		read -p "Do you want to see your linux version[y/N]? " kv
		if [[ $kv == "y" || $kv == "Y" ]]
		then
			vk=$(cat /etc/os-release | grep VERSION= | sed -n 's/[A-Z"=]//g;p')
			echo -e "${BOLD}"
			echo -e "${GREEN}[*] Your kali version is:${RED} $vk${GREEN}."
		else
			echo -e "${GREEN}[✓] ${CYAN}Done!"
			pause 'Press [Enter] to continue'
		fi
		echo ""
		sudo dpkg --add-architecture i386
		sleep 1
		echo -e $MAGENTA ""
		read -p "[*] Do you want install many packages[y/N]?: " pck
		if [[ $pck == "y" || $pck == "Y" ]]
		then
			clear
			echo -e "[~] ${GREEN}Installing new packages, get something to drink and relax."
			sleep 0.5
			sudo apt-get install neofetch lynx xpdf speedtest-cli python3 tor tor-arm torbrowser-launcher proxychains proxychains4 filezilla gdebi geany neofetch git bettercap ngrep curl mdk3 mdk4 bc cowpatty php-cgi php apache2 libssl-dev gpa gnupg2 net-tools wget postfix libncurses5 libxml2 tcpdump libexiv2-dev build-essential python-pip ssh ssh-tools htop stacer bleachbit leafpad snapd yersinia cmake make g++ gcc openssh-server openssl screen wapiti whatweb nmap wget uniscan wafw00f dirb davtest theharvester xsser dnsrecon fierce dnswalk whois sslyze lbd dnsenum dmitry davtest nikto dnsmap netcat gvfs gvfs-common gvfs-daemons gvfs-libs gconf-service gconf2 gconf2-common gvfs-bin psmisc filezilla filezilla-common gdebi vlc firmware-misc-nonfree firmware-netxen firmware-realtek apktool maven default-jdk default-jre openjdk-8-jdk libncurses5-dev lib32z1 lib32ncurses6 -y
			sed -i s/geteuid/getppid/g /usr/bin/vlc
			clear
			echo -e $GREEN "[✓] ${CYAN}Packages has been successfully installed."
			echo -e "${GREEN}[i] ${BLUE}Done."
			pause 'Press [Enter] go back to menu'
			Aonfig
		fi
	}

	kali_pack(){
		echo -e $BOLD "${YELLOW}"
		figlet -f slant "KaliTools"
		clear
		echo ''
		echo -e $BOLD "${BLUE}
${BLUE}[i] ${RED}Kali linux has some metapackages, means it installs particular stuff you maybe need, i will list some options which you can choose to continue.
${BLUE}[1] ${RED}802-11 Tools		-:- ${YELLOW}Kali Linux 802.11 attacks tools
${BLUE}[2] ${RED}Bluetooth Tools 		-:- ${YELLOW}Kali Linux bluetooth attacks tools
${BLUE}[3] ${RED}Crypt & Stego Tools		-:- ${YELLOW}Kali Linux Cryptography and Steganography tools
${BLUE}[4] ${RED}Database Tools 	 	-:- ${YELLOW}Kali Linux database assessment tools menu
${BLUE}[5] ${RED}Exploitation Tools		-:- ${YELLOW}Kali Linux exploitation tools menu
${BLUE}[6] ${RED}Forensics Tools 		-:- ${YELLOW}Kali Linux forensic tools menu
${BLUE}[7] ${RED}Fuzzing Tools 		-:- ${YELLOW}Kali Linux fuzzing attacks tools
${BLUE}[8] ${RED}GPU Tools 			-:- ${YELLOW}Kali Linux GPU tools	
${BLUE}[9] ${RED}Hardware Tools 		-:- ${YELLOW}Kali Linux hardware attacks tools
${BLUE}[10] ${RED}Headless Tools 		-:- ${YELLOW}Kali Linux headless tools
${BLUE}[11] ${RED}Information Gathering	-:- ${YELLOW}Kali Linux information gathering menu
${BLUE}[12] ${RED}Password Tools 		-:- ${YELLOW}Kali Linux password cracking tools menu
${BLUE}[13] ${RED}Post Exploitation		-:- ${YELLOW}Kali Linux post exploitation tools menu
${BLUE}[14] ${RED}Reporting Tools 		-:- ${YELLOW}Kali Linux reporting tools menu
${BLUE}[15] ${RED}Reverse Engineer	 	-:- ${YELLOW}Kali Linux reverse engineering menu
${BLUE}[16] ${RED}RFID Tools 		-:- ${YELLOW}Kali Linux RFID tools
${BLUE}[17] ${RED}SDR Tools 			-:- ${YELLOW}Kali Linux SDR tools
${BLUE}[18] ${RED}Sniffing & Spoofing	-:- ${YELLOW}Kali Linux sniffing & spoofing tools menu
${BLUE}[19] ${RED}Social Engineering	   	-:- ${YELLOW}Kali Linux social engineering tools menu
${BLUE}[20] ${RED}Top 10 Tools 		-:- ${YELLOW}Kali Linux top 10 tools
${BLUE}[21] ${RED}VoiceIP Tools		-:- ${YELLOW}Kali Linux VoIP tools
${BLUE}[22] ${RED}Vulnerability Tools 	-:- ${YELLOW}Kali Linux vulnerability analysis menu
${BLUE}[23] ${RED}Web Tools			-:- ${YELLOW}Kali Linux webapp assessment tools menu
${BLUE}[24] ${RED}Windows Tools		-:- ${YELLOW}Kali Linux Windows resources
${BLUE}[25] ${RED}Wireless Tools 		-:- ${YELLOW}Kali Linux wireless tools menu
${BLUE}[all] ${RED}All Tools			-:- ${YELLOW}Installing all tools of kali
${BLUE}[c] ${RED}Skipping this and will skip this.
${BLUE}[back] ${RED}Back
${BLUE}[q] ${RED}Quit the module
"
		txt=0
		while [ $txt = 0 ] 
		do
			echo -ne "${RED}【 mak3r@github 】${YELLOW}/full_config/packages ${BLUE}~>: "
			read kali
			case "$kali" in
				1) sudo apt install kali-tools-802-11 -y; txt=1;;
				2) sudo apt install kali-tools-bluetooth -y; txt=1;;
				3) sudo apt install kali-tools-crypto-stego -y; txt=1;;
				4) sudo apt install kali-tools-database -y; txt=1;;
				5) sudo apt install kali-tools-exploitation -y; txt=1;;
				6) sudo apt install kali-tools-forensics -y; txt=1;;
				7) sudo apt install kali-tools-fuzzing -y; txt=1;;
				8) sudo apt install kali-tools-gpu -y; txt=1;;
				9) sudo apt install kali-tools-hardware -y; txt=1;;
				10)	sudo apt install kali-tools-headless -y; txt=1;;
				11) sudo apt install kali-tools-information-gathering -y; txt=1;;
				12) sudo apt install kali-tools-passwords -y; txt=1;;
				13) sudo apt install kali-tools-post-exploitation -y; txt=1;;
				14) sudo apt install kali-tools-reporting -y; txt=1;;
				15)	sudo apt install kali-tools-reverse-engineering -y; txt=1;;
				16) sudo apt install kali-tools-rfid -y; txt=1;;
				17) sudo apt install kali-tools-sdr -y; txt=1;;
				18) sudo apt install kali-tools-sniffing-spoofing -y; txt=1;;
				19) sudo apt install kali-tools-social-engineering -y; txt=1;;
				20) sudo apt install kali-tools-top10 -y; txt=1;;
				21) sudo sudo apt install kali-tools-voip -y; txt=1;;
				22) sudo apt install kali-tools-vulnerability -y; txt=1;;
				23) sudo apt install kali-tools-web -y; txt=1;;
				24)	sudo apt install kali-tools-windows-resources; txt=1;;
				25)	sudo apt install kali-tools-wireless -y; txt=1;;
				all) sudo apt install kali-tools-802-11 kali-tools-bluetooth kali-tools-crypto-stego kali-tools-database kali-tools-exploitation kali-tools-forensics kali-tools-fuzzing kali-tools-gpu kali-tools-hardware kali-tools-headless kali-tools-information-gathering kali-tools-passwords  kali-tools-post-exploitation kali-tools-reporting kali-tools-reverse-engineering kali-tools-rfid kali-tools-sdr kali-tools-sniffing-spoofing kali-tools-social-engineering kali-tools-top10 kali-tools-voip kali-tools-vulnerability kali-tools-web kali-tools-windows-resources kali-tools-wireless -y; txt=1;;
				c) txt=1;;
				back) full_config; txt=1;;
				q) txt=1;;
			esac
		done
	}

	update(){
		clear
		echo ""
		printf "${RED}[?] ${YELLOW}Name of command: "
		read updd
		echo ""
		echo -e "
${updd}(){
	sudo apt-get update &&
	sudo apt-get dist-upgrade -y &&
	sudo apt-get autoremove -y &&
	sudo apt-get autoclean &&
	sudo apt-get clean
}		" >> ~/.bashrc
		echo -e "${RED}[!] ${BLUE}Type ${RED}$updd ${BLUE}to make a full update for your kali linux."
		echo -e "${MAGENTA}[!] ${RED}To see changes, close terminal and start terminal again!"
		clear
		echo -e $BOLD ""
		echo -e "${GREEN}[i] ${BLUE}Done."
		pause 'Press [Enter] go back to menu'
		full_config
	}

	tor(){
		printf "${RED}[*] ${YELLOW}Do you want to install tor browser[Y/N]? "
		read tr
		if [[ $tr == "y" || $tr == "Y" ]]
		then
			echo -ne "${RED}[*] ${YELLOW}Installing Tor Browser..";run;printf "\n\n"
			sleep 1.5
			clear
                        echo -e "${RED}[*] ${YELLOW}Adding Tor Project repository key."
                        local tor_keyring="/usr/share/keyrings/tor-archive-keyring.gpg"
                        local tor_sources="/etc/apt/sources.list.d/torproject.list"
                        local tor_log="${path}/logs/apt/torbrowser-install.log"
                        mkdir -p "$(dirname "$tor_log")"
                        local tor_success=0
                        if install_apt_key "https://deb.torproject.org/torproject.org/torproject-keyring.gpg" "$tor_keyring" >"$tor_log" 2>&1; then
                                echo -e "${GREEN}[i] ${BLUE}Key installed."
                                local codename
                                codename=$(get_release_codename)
                                local repo_entry="deb [signed-by=${tor_keyring}] https://deb.torproject.org/torproject.org ${codename} main"
                                write_repo_entry "$repo_entry" "$tor_sources"
                                echo -e "${RED}[*] ${YELLOW}Updating & configuring changes."
                                if run_as_root apt-get update >>"$tor_log" 2>&1 && run_as_root apt-get install -y tor torbrowser-launcher >>"$tor_log" 2>&1; then
                                        echo -e "${GREEN}[✓] ${CYAN}Done!."
                                        tor_success=1
                                else
                                        print_error "Tor Browser installation failed. Check ${tor_log}."
                                fi
                        else
                                print_error "Unable to install Tor repository key. Check ${tor_log}."
                        fi
                        if [[ $tor_success -eq 1 ]]; then
                                pause 'Press [Enter] to continue'
                                read -p "Do you want to start tor browser[Y/N]? " str
                                if [[ $str == "y" || $str == "Y" ]]
                                then
                                        torbrowser-launcher
                                fi
                        fi
                        pause 'Press [Enter] go back to menu'
                        full_config
		else
			echo -ne "${GREEN}[~] ${RED}Skipping..";run;printf "\n\n"
			pause 'Press [Enter] to continue....'
			clear
			echo -e "${GREEN}[i] ${BLUE}Done."
			pause 'Press [Enter] go back to menu'
			full_config
		fi	

	}

	dns(){
		clear
		echo -e "${YELLOW}[*] ${BLUE}Adding secure DNS server in /etc/resolv.conf."
		clear 
		echo -e "${RED}[*] ${YELLOW}Listening your currently dns server:(ignoring comments)"
		cat /etc/resolv.conf | sed '/#/d'
		sleep 1
		read -p "[?] Backup resolv.conf file[Y/N]?: " bck
		if [[ $bck == "y" || $bck == "Y" ]]
		then
			echo -e "${BLUE}[*] ${GREEN}Backup original file..."
			sleep 0.2
			cp -R /etc/resolv.conf $path/backup 2&>${path}/logs/log-cp-resolv.log

		else
			echo -e "${GREEN}[~] ${RED}Skipping";run;printf "\n\n"
			pause 'Press [Enter] to continue'
			clear
		fi
		pause 'Press [Enter] to continue'
		sleep 0.5
		clear
		printf "${MAGENTA}[*] ${GREEN}(A)nonymous DNS, (F)ast DNS or (Q)uit(skip)[A/F/Q]?: "
		read dns
		if [[ $dns == "A" || $dns == "A" ]]
		then
			clear
			echo -e "${BLUE}"
			figlet An0nM0de
			sleep 1
			echo -e "${RED}[!] ${MAGENTA}Adding following IP address to your DNS list: "
			sleep 0.5
			cat lib/anon_dns.txt | sed -r '/#/d'
			sudo mv /etc/resolv.conf backup/; sudo touch /etc/resolv.conf
			cat lib/anon_dns.txt 2>/dev/null | tail -n2 >> /etc/resolv.conf
			sleep 0.8
			echo -e "${GREEN}[i] ${BLUE}Done."
			pause 'Press [Enter] go back to menu'
			full_config

		elif [[ $dns == "f" || $dns == "F" ]]		
		then
			clear 
			echo -e "${BLUE}"
			figlet F4stM0de
			sleep 1
			echo -e "${RED}[!] ${MAGENTA}Adding following IP address to your DNS list: "
			sleep 0.5
			cat lib/fast_dns.txt | sed -r '/#/d'
			#sed -r '1,2 s/#/\r/' 
			sudo mv /etc/resolv.conf backup/; sudo touch /etc/resolv.conf
			cat lib/fast_dns.txt 2>/dev/null | tail -n2 >> /etc/resolv.conf
			sleep 0.8
			echo -e "${GREEN}[i] ${BLUE}Done."
			pause 'Press [Enter] go back to menu'
			full_config
		else
			echo -e "${GREEN}[i] ${BLUE}Skipped."
			pause 'Press [Enter] go back to menu'
			full_config
		fi
	}
	sourcesbk(){
		clear
		echo -e "${YELLOW}[*] ${BLUE}Setup Repository : /etc/apt/sources.list."
		clear 
		echo -e "${RED}[*] ${YELLOW}Printing current sources.list file:"
		cat /etc/apt/sources.list | sed '/#/d'
		sleep 1
		read -p "[?] Backup sources.list file[Y/N]?: " bck
		if [[ $bck == "y" || $bck == "Y" ]]
		then
			echo -e "${BLUE}[*] ${GREEN}Backup original file..."
			sleep 0.2
			cp -R /etc/apt/sources.list $path/backup 2&>$path/logs/copy-sources.log

		else
			echo -e "${GREEN}[~] ${RED}Skipping";run;printf "\n\n";sleep 0.5
			pause 'Press [Enter] to continue'
			clear
		fi
	}


	password(){
		clear
		echo -ne "${GREEN}[*] ${BLUE}Do you want to generate a password for your own security?[Y/N]?:${GREEN} "
		read pwdg
		if [[ $pwdg == "y" || $pwdg == "Y" ]]
		then
			bash lib/pwd.sh
		fi
		echo -e "${GREEN}[i] ${BLUE}Done."
		pause 'Press [Enter] go back to menu'
		full_config
	}


	openvpn(){
		printf '[?] Do you want to configure an openvpn account?[y/N]'
		read ovpn
		if [[ $ovpn == "y" || $ovpn == "Y" ]]
		then
			echo -e "${RED}[*]${YELLOW}Getting credentials..."
			sleep 1.2
			echo -e "${GREEN}[*] ${YELLOW}Successfully got credentials."
			echo -e "${RED}[*] ${YELLOW}Your username is: ${GREEN}${username}"
			echo -e "${RED}[*] ${YELLOW}Your password is: ${GREEN}${password}"
			echo -e $GREEN ""
			read -p "[?] Do you want to make an ovpn account now?[Y/N]: " moa
                        if [[ $moa == "y" || $moa == "Y" ]]
                        then
                                local openvpn_dir="$path/openvpn"
                                local bundle
                                bundle=$(download_latest_freevpn_bundle "$openvpn_dir") || {
                                        pause 'Press [Enter] go back to menu'
                                        full_config
                                        return
                                }
                                cd "$openvpn_dir"
                                unzip -o "$bundle"
                                rm -f "$bundle"
                                if command -v rename >/dev/null 2>&1; then
                                        find . -depth -name '* *' -exec rename 's/ /-/g' {} + 2>/dev/null || true
                                fi
                                if command -v xterm >/dev/null 2>&1; then
                                        xterm -e bash openvpn.sh
                                else
                                        bash openvpn.sh
                                fi
                                cd "$path"
                        fi
			clear
			#xterm -e cd openvpn; bash openvpn.sh&
		else
			echo -e "${GREEN}[i] ${BLUE}Skipped."
			pause 'Press [Enter] go back to menu'
			full_config
		fi
	}

        editor(){
                brackets() {
                        if ensure_snapd_ready; then
                                run_as_root snap install brackets --classic
                                echo "[*] Brackets has been successfully installed via Snap."
                        fi
                }
                atom() {
                        if ensure_snapd_ready; then
                                run_as_root snap install atom --classic
                                echo "[*] Atom has been successfully installed."
                        fi
                }
                visualcode() {
                        if ensure_snapd_ready; then
                                run_as_root snap install --classic code
                                echo "[*] Visual Studio Code has been successfully installed."
                        fi
                }
                bluefish() {
                        run_as_root apt-get install bluefish -y
                        echo "[*] Bluefish editor has been successfully installed."
                }

                geany() {
                        run_as_root apt-get install geany -y
                        echo "[*] Geany editor has been installed."
                }

		r=0
		while [ $r = 0 ]
		do
			cat <<-MENU
${YELLOW}EDITOR INSTALLATION MENU ${BLUE}

- -     (b)rackets      - -

- -     (a)tom          - -

- -     (v)isual Code   - -

- -     (g)eany         - -

- -     (l)uefish       - -

- -     (s)kip          - -
MENU

			echo -e "${RED}Type the letter in () in lowercase f.e: a for atom."
			echo -ne "${GREEN}[?] Which linux code editor you would use?: "
			read name
			case "$name" in
				b) brackets; r=1;;
				a) atom; r=1;;
				v) visualcode; r=1;;
				l) bluefish; r=1;;
				g) geany; r=1;;
				s) r=1;;
				*) echo '[!] Wrong command!'; sleep 1; r=0;;
			esac
		done

	}

        iso(){
                echo -e $RED "[*] ${YELLOW}Loading some other configurating options..."
                sleep 2
                clear
                echo -ne $RED"[?] ${MAGENTA}Do you want to install an ISO burner[Y/N]?: "
                read etch
                if [[ $etch == "Y" || $etch == "y" ]]
                then
                        clear
                        local download_dir="$HOME/Downloads"
                        mkdir -p "$download_dir"
                        cd "$download_dir"
                        local etcher_url
                        etcher_url=$(github_latest_asset "balena-io/etcher" 'linux-x64.*\\.zip')
                        if [[ -z "$etcher_url" ]]; then
                                print_error "Unable to determine the latest balenaEtcher release."
                                pause 'Press [Enter] go back to menu'
                                full_config
                                return
                        fi
                        local etcher_zip="$(basename "$etcher_url")"
                        curl -fLo "$etcher_zip" "$etcher_url"
                        unzip -o "$etcher_zip"
                        rm -f "$etcher_zip"
                        local app_image
                        app_image=$(find . -maxdepth 1 -type f -name 'balenaEtcher-*-x64.AppImage' | head -n1)
                        if [[ -z "$app_image" ]]; then
                                print_error "balenaEtcher AppImage not found after extraction."
                                pause 'Press [Enter] go back to menu'
                                full_config
                                return
                        fi
                        if [ -f /usr/bin/iso-burner ]; then
                                clear
                                echo -e "${GREEN}[*] ${MAGENTA}Existing iso-burner detected. Updating binary."
                        else
                                clear
                                echo -e "${RED}[!] ${MAGENTA}Installing balenaEtcher launcher."
                        fi
                        run_as_root mv "$app_image" /usr/bin/iso-burner
                        run_as_root chmod +x /usr/bin/iso-burner
                        cd "$path"
                        clear
                        echo -e "${GREEN}[*] ${BLUE}You have successfully installed balena etcher."
                        echo -e "${GREEN}[*] ${BLUE}To run this tool type ${RED}iso-burner ${BLUE}do not remove the file from /usr/bin."
                        sleep 0.3
                fi
                pause 'Press [Enter] go back to menu'
                full_config
	}

	connection(){
		clear
		echo -e "${RED}[!] ${CYAN}Testing your internet speed right now..."
		sleep 2
		cd lib
		echo ""
		rm results.txt
		speedtest >> results.txt
		echo -ne "${GREEN}[*] ${MAGENTA}Your provider is: "
		cat results.txt | grep from | awk '{print $3 " " $4 " " $5}'
		sleep 0.5
		echo -ne "${GREEN}[*] ${MAGENTA}Your ms/ping is: "
		head -n5 results.txt | tail -1 | awk 'NF>1{print $9, $NF}'
		sleep 0.5
		echo -ne "${GREEN}[*] ${MAGENTA}Your download speed is: "
		cat results.txt | grep Download | awk '{print $2, $3}'
		sleep 0.5
		echo -ne "${GREEN}[*] ${MAGENTA}Your upload speed is:"
		cat results.txt | grep Upload | awk '{print $2, $3}'
		sleep 1
		echo -e "${RED}[!] ${BLUE}Your original IP is: ${YELLOW}$ipaddr"
		echo -ne "${GREEN}[*] ${MAGENTA}Your current IP address is : "
		curl ipinfo.io/ip
		cd ..
		echo ""
		echo -e "${GREEN}[✓] ${YELLOW}Speedtest Successfully Done."	
		pause 'Press [Enter] go back to menu'
		full_config
	}

	fc=0
	while [ $fc = 0 ]
	do
		echo -ne "${BLUE}【 mak3r@github 】${YELLOW}/full_config ${BLUE}~>:${RED} "
		read f
		case "$f" in
			1) sources; fc=1;;
			2) packages; fc=1;;
			3) kali_pack; fc=1;;
			4) update; fc=1;;
			5) tor; fc=1;;
			6) dns; fc=1;;
			7) password; fc=1;;
			8) openvpn; fc=1;;
			9) editor; fc=1;;
			10) iso; fc=1;;
			11) connection; fc=1;;
			back) main; fc=1;;
			*) echo -e "${RED}Wrong input!"; fc=0;;
		esac
	done

}


install_tools() {
    local SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/lib/tool_installer.sh"
    tool_installer_menu
}


misc() {
	clear
	echo -e $MAGENTA""
	figlet MisC_0pti0nS
	echo -e "
${GREEN}[1] ${BLUE}Delete Bash History
${GREEN}[2] ${BLUE}Print All IPs Up In Network
${GREEN}[3] ${BLUE}Check Open Ports
${GREEN}[4] ${BLUE}When Feeling Down, Select This :)
${GREEN}[5] ${BLUE}Remove All Empty Directories [PLEASE THINK ABOUT IT]
${GREEN}[6] ${BLUE}MS-DOS PS1 Design (temporarly)
${GREEN}[7] ${BLUE}Heavy Matrix Shit
${GREEN}[8] ${BLUE}Get Your Local IPs & Hostname
${GREEN}[9] ${BLUE}Extract Audio From A Video	
${GREEN}[10] ${BLUE}List Most Used Commands
${GREEN}[11] ${BLUE}Fix Broken Sound
${GREEN}[12] ${BLUE}Block Spam Hosts
${GREEN}[13] ${BLUE}Prints All Opened Ports On Localhost
${GREEN}[14] ${BLUE}Generate Password (+Length Option, +Save)
${GREEN}[15] ${BLUE}System Information
${GREEN}[16] ${BLUE}When System Was Installed
${GREEN}[17] ${BLUE}Reset Damaged Terminal
${GREEN}[18] ${BLUE}Print Apps Which Using Internet Connection
${GREEN}[19] ${BLUE}Get Info About A Target Website (OS Detection, Hosts, Ports)
${GREEN}[20] ${BLUE}Fix APT Install Errors (NOT FINISHED YET)
${GREEN}[21] ${BLUE}Removing Log Files For Security Reasons (Requires Root)
${GREEN}[back] ${BLUE}Back To Menu

${RED}More Coming Soon :)
	"
	
	
	printf "${RED}【 mak3r@github 】 ${YELLOW}/misc ${BLUE}~>: "
	read sm
	if [[ $sm == 1 ]]
	then
		clear
		echo -e "${RED}[!] Using sudo."
		sleep 0.5
		echo "# Cleared by @aut0_mak3r" > ~/.bash_history
 		echo -e "${GREEN}[i] ${BLUE}Done."
		echo -e $CYAN""
		pause 'Press [ENTER] to go back'
		misc
	elif [[ $sm == 2 ]]
	then
		clear
		arp | grep ether | awk '{print "Found IP: " $1 " which has MAC: " $3 }'
		echo -e $CYAN""
		pause 'Press [ENTER] to go back'
		misc
	elif [[ $sm == 3 ]]
	then
		clear
		echo -e "${GREEN}Found(if nothing then good!): "
		lsof -Pni4 | grep LISTEN
		echo -e $CYAN""
		pause 'Press [ENTER] to go back'
		misc
	elif [[ $sm == 4 ]]
	then
		sudo apt install sl
		clear
		sl -F
		pause 'Press [ENTER] to go back'
		misc
	elif [[ $sm == 5 ]]
	then
		clear
		find . -type d -empty -delete
		echo -e $CYAN""
		pause 'Press [ENTER] to go back'
		misc
	elif [[ $sm == 6 ]]
	then
		clear
		PS1="C:\$( pwd | sed 's:/:\\\\\\:g' )\\> "
		misc
	elif [[ $sm == 7 ]]
	then
		clear
		echo -e "${YELLOW}Press ${RED}CTRL+C ${YELLOW}to quit."
		pause 'Press [ENTER] to continue'
		timeout 3s bash lib/matrix.sh
		misc
	elif [[ $sm == 8 ]]
	then
		clear
		echo -e "${YELLOW}[*] All IPs:${RED} "
		ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'
		echo -e $CYAN""
		pause 'Press [ENTER] to continue'
		misc
	elif [[ $sm == 9 ]]
	then
		clear
		echo -ne "${YELLOW}[*] ${GREEN}Enter Video Path(~/Videos/video.mp4):${BLUE} "; read video
		echo -ne "${YELLOW}[*] ${GREEN}Enter Output Name(~/Videos/audio.mp3):${BLUE} "; read audio
		ffmpeg -i $video -f mp3 $audio &>/dev/null
		if [ -f $audio ]
		then	
			echo -e "${GREEN}[*] ${YELLOW}Successfully saved in: ${BLUE}$audio"
		else
			clear
			echo -e "${RED}[*] ${YELLOW}Damn.. Try again!"
		fi
		echo -e $CYAN""
		pause 'Press [ENTER] to go back'
		misc
	elif [[ $sm == 10 ]]
	then
		clear
		history | awk '{print $2}' | sort | uniq -c | sort -rn | head
		echo -e $CYAN""
		pause 'Press [ENTER] to go back'
		misc
	
	elif [[ $sm == 11 ]]
	then
		clear
		sudo killall -9 pulseaudio; pulseaudio >/dev/null 2>&1 &
		misc
	elif [[ $sm == 12 ]]
	then
		clear
            wget -q -O - https://someonewhocares.org/hosts/hosts | grep ^127 | run_as_root tee /etc/hosts >/dev/null
		#wget -qO - http://infiltrated.net/blacklisted | awk '!/#|[a-z]/&&/./{print "iptables -A INPUT -s "$1" -j DROP"}'
		# potentially broken

		echo -e $CYAN""
		misc
	elif [[ $sm == 13 ]]
	then
		clear
		nmap -p 1-64435 --open localhost | grep tcp | cut -d\  -f1 | awk '{print "\033[34;1m[\033[31mOPEN\033[34m] \033[32mDetected Port: \033[37m" $1}'
		echo -e $CYAN""
		pause 'Press [ENTER] to go back'
		misc
	elif [[ $sm == 14 ]]
	then
		clear
		echo -ne "${YELLOW}[*] ${RED}How long should the password be: "
		read long
		openssl rand -base64 $long >> $path/pwd.txt; 
		v=$(cat $path/pwd.txt)
		echo -e "${GREEN}[i] ${BLUE}Generated password: ${YELLOW}$v"
		echo -e $CYAN""
		pause 'Press [ENTER] to go back'
		misc
	elif [[ $sm == 15 ]]
	then
		clear
		neofetch
		echo -e $CYAN""
		pause 'Press [ENTER] to go back'
		misc
	elif [[ $sm == 16 ]]
	then
		clear
		f=$(ls -lct /etc/ | tail -1 | awk '{print $6, $7, $8}')	
		echo -e "${GREEN}[i] ${BLUE}System was installed at ${YELLOW}$f"
		echo -e $CYAN""
		pause 'Press [ENTER] to go back'
		misc
	elif [[ $sm == 17 ]]
	then
		clear
		reset
		misc
	elif [[ $sm == 18 ]]
	then
		clear
		lsof -P -i -n | cut -f 1 -d " "| uniq | tail -n +2
		echo -e $CYAN""
		pause 'Press [ENTER] to go back'
		misc
	elif [[ $sm == 19 ]]
	then
		clear
		echo -ne "${GREEN}[i] ${YELLOW}Enter Target Wesbite(test.com):${RED} "
		read target
		sudo nmap -sS --top-ports "1000" -sV -O -Pn -vv $target
		echo -e $CYAN""
		pause 'Press [ENTER] to go back'
		misc
	elif [[ $sm == 21 ]]
	then
		clear
		echo -e "${GREEN}[i] ${BLUE}Clearing logs...."
		sleep 1
		sudo echo '' > /var/log/*.log || echo -e "${RED}[!] ${YELLOW}Cannot overwrite logs, make sure you use root!"
		pause 'Press [ENTER] to go back'
		misc
	elif [[ "$sm" == "back" ]]
	then
		clear
		main
		clear
	else
		echo "${RED}[!] Wrong command"
		misc
	fi
}

tt() {
	clear
	termux_tools
}

###############################


termux_tools() {

	update_ter() {
		clear
		echo -e "${GREEN}[*] ${YELLOW}Installing updates, hold on.."
		apt update
		apt upgrade -y
		pkg upgrade -y
		echo -e "${GREEN}[*] ${YELLOW}Done."
		pause 'Press [ENTER] to go back'
		termux_tools
	}

	install_pck() {
		clear
		echo -e "${GREEN}[*] ${YELLOW}Installing Termux packages, hold on.."
		sleep 1
		chmod +x $path/lib/installer.sh
		bash $path/lib/installer.sh
		echo -e "${RED}[!] ${YELLOW}Please run the update for termux, some packages has been added, an update is required!(choose 1 in the menu)"
		sleep 1.5
		echo -e "${GREEN}[*] ${YELLOW}Done."
		sleep 1
		pause 'press [ENTER] to continue'
		termux_tools
	}

	mobile_pt() {
		instagram() {
			clear
			figlet "Loading Module."
			sleep 0.5; clear
			figlet "Loading Module.."
			sleep 0.5; clear
			figlet "Loading Module..."
			sleep 0.5; clear
			echo -e "${GREEN}"
			figlet "Loaded!"
			sleep 0.5
			echo -e "${RED}We are installing some repositories hit enter to begin> "
			#echo -e "${GREEN}[i] ${BLUE}Creating directory : ${YELLOW}insta-collection"
			sleep 1
			echo -e "${BLUE}Path: ${GREEN}:$PWD"
			pause 'Press Enter'
			#cd aut0_mak3r
			bash lib/insta.sh

		}

		viperzcrew() {
			clear
			figlet "Loading Module."
			sleep 0.5; clear
			figlet "Loading Module.."
			sleep 0.5; clear
			figlet "Loading Module..."
			sleep 0.5; clear
			echo -e "${GREEN}"
			figlet "Loaded!"
			sleep 0.5
			echo -e "${RED}We are installing some repositories hit enter to begin> "
			#echo -e "${GREEN}[i] ${BLUE}Creating directory : ${YELLOW}website
			sleep 1
			echo -e "${BLUE}Path: ${GREEN}:$PWD"
			pause 'Press Enter'
			cd aut0_mak3r
			bash lib/viperzcrew.sh
		}

		facebook() {
			echo -e "${GREEN}[i] ${BLUE}Under progress ;)"
			pause 'Press [Enter] To Go Back'
			termux_tools
		}

	
		clear
		figlet M0biL3_penT3st
		echo -e "
${RED}[1] ${YELLOW}Instagram Collection ${GREEN}==> ${BLUE}Installing Instagram Tools
${RED}[2] ${YELLOW}ViperZCrew Special   ${GREEN}==> ${BLUE}Installing Website Tools
${RED}[3] ${YELLOW}Facebook Collection	 ${GREEN}==> ${BLUE}Installing Facebook Tools
${RED}[4] ${YELLOW}DDoS Downloader	 ${GREEN}==> ${BLUE}Installing A DDoS Downloader Tool(Linux/Termux)
${RED}[5] ${YELLOW}Metasploit		 ${GREEN}==> ${BLUE}Installing Metasploit Framework
${RED}[back] ${YELLOW}Back To Termux Tools 
${RED}[main] ${YELLOW}Back To Main Menu
	"
		ds=0
		while [ $ds = 0 ]
		do
			echo -ne "${RED}【 mak3r@github 】 ${YELLOW}/termux_tools/mobile_pentest ${BLUE}~>: "
			read tood
			case "$tood" in
				1) clear; instagram; ds=1;;
				2) clear; viperzcrew; ds=1;;
				3) clear; facebook; ds=1;;
				4) clear; echo ""; echo -e "${RED}[*] ${YELLOW}DDoS Downloader installation...."; cd $HOME; git clone https://github.com/ViperZCrew/DDoS_Downloader; cd DDoS_Downloader; chmod +x *.sh; echo -e "${RED}[*] ${YELLOW}Done, installed in ${BLUE}$path ${YELLOW}to run type: ${GREEN}bash ddos_downloader.sh"; sleep 1; pause 'Press [ENTER] to go back.'; termux_tools; ds=1;;
				5) clear; echo -e "${RED}[*] ${YELLOW}Metasploit framework installation...."; pkg install unstable-repo -y; sleep 1; echo -e "${RED}[*] ${YELLOW}This take a lot of time, chill out."; apt install metasploit -y; pause 'Press [ENTER] to go back.'; termux_tools; ds=1;;
				back) termux_tools; ds=1;;
				main) main; ds=1;;
				*) echo '[!] Wrong command!'; sleep 1;;
			esac
		done
	}

	clear
	figlet TermuXT00Ls
	cd $HOME
	echo -e "
${BLUE}PATH: ${GREEN}:$path

${RED}[1] ${YELLOW}Updating System
${RED}[2] ${YELLOW}Installing Packages
${RED}[3] ${YELLOW}Mobile Pentesting
${RED}[4] ${YELLOW}Custom PS1 (mrblackx's special)
${RED}[menu] ${YELLOW}Back To Main Menu
	"
	tto=0
	while [ $tto = 0 ]
	do
		echo -ne "${RED}【 mak3r@github 】 ${YELLOW}/termux_tools ${BLUE}~>: "
		read termt
		case $termt in
			1)
			update_ter
			tto=1
			;;
			2)
			install_pck
			tto=1
			;;
			3)
			mobile_pt
			tto=1
			;;
			4)
			custom_term
			tto=1
			;;
			menu)
			cd $path
			[ -z "$AUTO_MAK3R_MODULAR" ] && bash 4ut0m4t10n.sh
			tto=1
			;;
			*)
			echo '[!] Wrong command!'
			sleep 1
			;;
		esac
	done
}

custom_term() {
	echo -ne "${RED}[*] ${YELLOW}Customize your terminal";run;printf "\n\n";sleep 0.5
	sleep 1
	echo -ne "${YELLOW}[>] ${RED}Enter your name:${BLUE} "
	read name
	echo -e "${GREEN}[*] ${BLUE}Doing the work";run;printf "\n\n";sleep 0.5
	sleep 2
	cd ..; cd ..
	cd /data/data/com.termux/files/usr/etc
	cp -R bash.bashrc $HOME/aut0_mak3r/backup
	mv -v bash.bashrc bash.bashrc.bak
	touch bash.bashrc
	echo "PS1='\[\e[0;1;92m\]Current Directory: \[\e[0;1;95m\]\w\[\e[m\]\n\[\e[0;1;91m\]\u\[\e[0;1;97m\]@\[\e[0;1;96m\]\H\[\e[0;1m\]~\[\e[0;1m\]:\[\e[m\] \[\e0'" >> bash.bashrc
	clear
	sleep 1
	cd ..; cd ..; cd home/aut0_mak3r
	echo -e "${GREEN}[*] ${YELLOW}Please restart your terminal."
	echo ""
	echo -e "${GREEN}[*] ${BLUE}To restore the default termux, type:${YELLOW}mv -v $path/backup/bash.bashrc /data/data/com.termux/file/usr/etc/bash.bashrc "
	pause 'press [ENTER] to go back'
	termux_tools
}



credits() {
	clear
	echo -e "
｡☆✼★━━━━━━━━━━━━━━━━━━━━━★✼☆｡	
		  ______________
╭━┳━╭━╭━╮╮       /  Credits to   \ 	 
┃┈┈┈┣▅╋▅┫┃	 | @TheMasterCH  |
┃┈┃┈╰━╰━━━━━━╮	 | Get some weed |
╰┳╯┈┈┈┈┈┈┈┈┈◢▉◣	  \_____________ /
╲┃┈┈┈┈┈┈┈┈┈▉▉▉	  //
╲┃┈┈┈┈┈┈┈┈┈◥▉◤ __//
╲┃┈┈┈┈╭━┳━━━━╯
╲┣━━━━━━┫

${GREEN}Coded by			: ${MAGENTA}MrBlackX
${GREEN}Fixed by			: ${MAGENTA}0n1cOn3
${GREEN}Insta Tools Collected 		: ${MAGENTA}BlackFlare
${GREEN}ViperZCrew Tools Collected	: ${MAGENTA}Legend
${GREEN}Facebook Tools Collected	: ${MAGENTA}MrBlackX
${RED}
｡☆✼★━━━━━━━━━━━━━━━━━━━━━★✼☆｡


${BLUE}Telegram : ${YELLOW}t.me/leakerhounds

${BLUE}Telegram : ${YELLOW}t.me/deepwaterleak2

${BLUE}Telegram : ${YELLOW}t.me/viperzcrew


${RED}｡☆✼★━━━━━━━━━━━━━━━━━━━━━★✼☆｡
	"
	echo -e "${GREEN}"
	pause 'Press [ENTER] to go back'
	[ -z "$AUTO_MAK3R_MODULAR" ] && bash 4ut0m4t10n.sh
	}

quit() {	
	clear
	echo -e "${RED}[*] ${YELLOW} Pre-setting options."
	pause 'Press [Enter] to continue'
	echo -ne "${RED}[*] ${CYAN}Quitting";run;printf "\n\n";sleep 0.5
	sleep 0.5
	clear
	exit
	}

os() {
	un=$(uname -m)
	if [[ $un == "x86_64" ]]
	then
		os=$(uname -o)
		echo -e "${RED}[i] ${GREEN}OS: ${RED}$os"
	else
		echo -e "${RED}[i] ${GREEN}OS: ${RED}Termux"
	fi
}
 
# handle module arguments
if [ -n "$1" ]; then
    case "$1" in
        full_config) full_config ;;
        install_tools) install_tools ;;
        misc) misc ;;
        termux_tools) termux_tools ;;
        credits) credits ;;
        tools) bash lib/communitytools.sh ;;
        quit) quit ;;
        *) echo "Unknown module: $1"; exit 1 ;;
    esac
    exit 0
fi

#banner

clear
sleep 0.5
echo -e $BLUE "

Welcome To

████████╗██╗  ██╗███████╗ ███▄ ▄███▓ ▄▄▄       ██ ▄█▀▓█████  ██▀███  
╚══██╔══╝██║  ██║██╔════╝ ▓██▒▀█▀ ██▒▒████▄     ██▄█▒ ▓█   ▀ ▓██ ▒ ██▒
   ██║   ███████║█████╗   ▓██    ▓██░▒██  ▀█▄  ▓███▄░ ▒███   ▓██ ░▄█ ▒
   ██║   ██╔══██║██╔══╝   ▒██    ▒██ ░██▄▄▄▄██ ▓██ █▄ ▒▓█  ▄ ▒██▀▀█▄ 
   ██║   ██║  ██║███████╗ ▒██▒   ░██▒ ▓█   ▓██▒▒██▒ █▄░▒████▒░██▓ ▒██▒
   ╚═╝   ╚═╝  ╚═╝╚══════╝  
"

echo -e $MAGENTA"${BOLD}The Automatic Configure Script For Linux.   "
echo ""
echo -e $RED"Version		: $version"
echo -e $GREEN"Tools		: 59"
echo -e $MAGENTA"Creator		: MrBlackX"
echo -e $MAGENTA"Maintainer          : 0n1c0n3"
echo -e $BLUE"Telegram 	: @viperzcrew"
echo ""
command_check
echo ""
update
echo ""
echo -e "${RED}[!] ${YELLOW}Directory of The makeR: ${MAGENTA}${path}."
echo ""
os
echo ""
echo -e "${RED}[i] ${GREEN}Hostname: ${RED}$host"
echo ""
sleep 0.2
printf "${RED}[> full_config <] ${YELLOW}   Start to configure your linux for hacking."
echo ""
sleep 0.2
printf "${RED}[> install_tools <] ${YELLOW} Automatic installation over 100 tools from github"
echo ""
sleep 0.2
printf "${RED}[> misc <] ${YELLOW} 	     Some extra command line linux tools"
echo ""
sleep 0.2
printf "${RED}[> termux_tools <] ${YELLOW}  Termux section for mobile users."
echo ""
sleep 0.2
printf "${RED}[> tools <]	${YELLOW}     Some tools from us for you"
echo ""
sleep 0.2
printf "${RED}[> credits <] ${YELLOW}       Lists credits & contact."
echo ""
sleep 0.2
printf "${RED}[> quit <] ${YELLOW}          Leaving(press q to quit)."
echo ""
echo ""
echo -e $BLUE ""

#main 

x=0
while [ $x = 0 ]
do
	echo -ne "【 mak3r@github 】~>:${RED} "
	read ex
	case "$ex" in
		full_config) full_config; x=1;;
		install_tools) install_tools; x=1;;
		misc) misc; x=1;;
		termux_tools) termux_tools; x=1;;
		credits) credits; x=1;;
		tools) bash lib/communitytools.sh; x=1;;
		quit) quit; x=1;;
		q) x=1; echo 'Exiting..'; sleep 0.5;;
		*) echo '[!] Wrong command!'; sleep 1;;
	esac
done
