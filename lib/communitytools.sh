#!/bin/bash

# colors

# Reset
rs='\033[m'

# Regular Colors
r='\033[0;31m'
g='\033[0;32m'
y='\033[0;33m'
b='\033[0;34m' 
p='\033[0;35m'
c='\033[0;36m'
w='\033[0;37m'

# Background
or='\033[41m'
og='\033[42m'
oy='\033[43m'
ob='\033[44m'
op='\033[45m'
oc='\033[46m'
ow='\033[47m'

# Bold

bd="\e[1m"

# Path
path=$(pwd)

# 

function main {
    printf '\e[8;40;120t'
    clear
    echo -e "${bd}
${ob}${bd}  ______   ______  __       __ __       __ __    __ __    __ ______ ________ __      __ ${rs}
${ob}${bd} /      \ /      \|  \     /  \  \     /  \  \  |  \  \  |  \      \        \  \    /  \ ${rs}     
${ob}${bd}|  ▓▓▓▓▓▓\  ▓▓▓▓▓▓\ ▓▓\   /  ▓▓ ▓▓\   /  ▓▓ ▓▓  | ▓▓ ▓▓\ | ▓▓\▓▓▓▓▓▓\▓▓▓▓▓▓▓▓\▓▓\  /  ▓▓ ${rs}     
${ob}${bd}| ▓▓   \▓▓ ▓▓  | ▓▓ ▓▓▓\ /  ▓▓▓ ▓▓▓\ /  ▓▓▓ ▓▓  | ▓▓ ▓▓▓\| ▓▓ | ▓▓    | ▓▓    \▓▓\/  ▓▓  ${rs}      
${ob}${bd}| ▓▓     | ▓▓  | ▓▓ ▓▓▓▓\  ▓▓▓▓ ▓▓▓▓\  ▓▓▓▓ ▓▓  | ▓▓ ▓▓▓▓\ ▓▓ | ▓▓    | ▓▓     \▓▓  ▓▓  ${rs}       
${ob}${bd}| ▓▓   __| ▓▓  | ▓▓ ▓▓\▓▓ ▓▓ ▓▓ ▓▓\▓▓ ▓▓ ▓▓ ▓▓  | ▓▓ ▓▓\▓▓ ▓▓ | ▓▓    | ▓▓      \▓▓▓▓  ${rs}        
${ob}${bd}| ▓▓__/  \ ▓▓__/ ▓▓ ▓▓ \▓▓▓| ▓▓ ▓▓ \▓▓▓| ▓▓ ▓▓__/ ▓▓ ▓▓ \▓▓▓▓_| ▓▓_   | ▓▓      | ▓▓  ${rs}         
${ob}${bd} \▓▓    ▓▓\▓▓    ▓▓ ▓▓  \▓ | ▓▓ ▓▓  \▓ | ▓▓\▓▓    ▓▓ ▓▓  \▓▓▓   ▓▓ \  | ▓▓      | ▓▓  ${rs}         
${ob}${bd}  \▓▓▓▓▓▓  \▓▓▓▓▓▓ \▓▓      \▓▓\▓▓      \▓▓ \▓▓▓▓▓▓ \▓▓   \▓▓\▓▓▓▓▓▓   \▓▓       \▓▓  ${rs}         
${ob}${bd}  ________  ______   ______  __         ______                                       ${rs}    
${ob}${bd} |        \/      \ /      \|  \       /      \ ${rs}   
${ob}${bd}  \▓▓▓▓▓▓▓▓  ▓▓▓▓▓▓\  ▓▓▓▓▓▓\ ▓▓      |  ▓▓▓▓▓▓\. ${rs}  ${y}__________________${rs}
${ob}${bd}    | ▓▓  | ▓▓  | ▓▓ ▓▓  | ▓▓ ▓▓     | ▓▓___ \▓▓ ${rs}   ${y}| .--------------. |${rs}
${ob}${bd}    | ▓▓  | ▓▓  | ▓▓ ▓▓  | ▓▓ ▓▓       \▓▓    \  ${rs}   ${y}| |${rs} ${r}yourporn.com${rs} ${y}| |${rs}
${ob}${bd}    | ▓▓  | ▓▓  | ▓▓ ▓▓  | ▓▓ ▓▓       _\▓▓▓▓▓▓\. ${rs}  ${y}| |${rs}  ${g}oh fuck!${rs}    ${y}| |${rs}
${ob}${bd}    | ▓▓  | ▓▓__/ ▓▓ ▓▓__/ ▓▓ ▓▓_____ |  \__| ▓▓ ${rs}   ${y}| |${rs} ${p}viperzcrew${rs}   ${y}| |${rs}
${ob}${bd}    | ▓▓   \▓▓    ▓▓\▓▓    ▓▓ ▓▓     \.\▓▓    ▓▓ ${rs}   ${y}| |              | |${rs}
${ob}${bd}     \▓▓    \▓▓▓▓▓▓  \▓▓▓▓▓▓ \▓▓▓▓▓▓▓▓  \▓▓▓▓▓▓ ${rs}    ${y}'-------)  (-------'${rs}
${ob}${bd}                                               ${rs}       ${y}_____[  ]_____${rs}
                                                      ${y}|::::::::::::::|\-${rs}
                                                      ${y}'=============='()${rs}
${or}by @ViperZCrew${rs}                                        ${or}Private Collection${rs}
${og}GitHub${rs}                                                ${og}https://github.com/rebl0x3r/aut0_mak3r${rs}
${oy}Directory:${rs}                                            ${oy}$path${rs}
${op}Version:${rs}                                              ${op}v0.1${rs}         
    "
    sleep 1
    printf "${g}[${y}1${g}] ${p}=> ${b}Combo Editor        (${r}Edit combos${b})${rs} "; sleep 0.2; echo -e "\t${g}[${y}12${g}] ${p}=> ${b}B00t3r${y}[${g}Windows${y}] ${b}  (${r}Windows Dead Ping${b})${rs}"; sleep 0.2
    printf "${g}[${y}2${g}] ${p}=> ${b}MySQL Exploiter     (${r}v5.6.35 and below${b})${rs}"; sleep 0.2; echo -e "\t${g}[${y}13${g}] ${p}=> ${b}FTP Exploit       (${r}ProFTPd 1.3.5${b})${rs}"; sleep 0.2
    printf "${g}[${y}3${g}] ${p}=> ${b}Proxyscraper v1     (${r}Proxy Grabber v1${b})${rs}"; sleep 0.2; echo -e "\t${g}[${y}14${g}] ${p}=> ${b}Gmail Bruter      (${r}Bruteforce Gmail${b})${rs}"; sleep 0.2
    printf "${g}[${y}4${g}] ${p}=> ${b}Proxyscraper v2     (${r}Proxy Grabber v2${b})${rs}"; sleep 0.2; echo -e "\t${g}[${y}15${g}] ${p}=> ${b}MAC Gen${y}[${g}Linux${y}] ${b}   (${r}Generate Random Mac${b})${rs}"; sleep 0.2
    printf "${g}[${y}5${g}] ${p}=> ${b}Dead Pinger         (${r}A Dead Ping Tool${b})${rs}"; sleep 0.2; echo -e "\t${g}[${y}16${g}] ${p}=> ${b}Pentestbox${y}[${g}Linux${y}] ${b}(${r}Pentest Tools Downloader${b})${rs}"; sleep 0.2
    printf "${g}[${y}6${g}] ${p}=> ${b}Instagram           (${r}Instagram Tools${b})${rs}"; sleep 0.2; echo -e "\t${g}[${y}17${g}] ${p}=> ${b}r00tw0rm${y}[${g}Linux${y}]   ${b}(${r}Private Tools${b})${rs}"; sleep 0.2
    printf "${g}[${y}7${g}] ${p}=> ${b}Password Tool       (${r}Generate Passwords${b})${rs}"; sleep 0.2; echo -e "\t${g}[${y}18${g}] ${p}=> ${b}Go to DDoS${y}        ${b}(${r}Over 100 DDoS Scripts${b})${rs}"; sleep 0.2
    printf "${g}[${y}8${g}] ${p}=> ${b}Payloader           (${r}Payload Creation${b})${rs}"; sleep 0.2; echo -e "\t${g}[${y}19${g}] ${p}=> ${b}SSH Exploit${y}       ${b}(${r}v5.3 <- only!${b})${rs}"; sleep 0.2
    printf "${g}[${y}9${g}] ${p}=> ${b}EvilWifi v1${y}[${g}Linux${y}]  ${b}(${r}BackTrack Wifi Hack${b})${rs}"; sleep 0.2; echo -e "${g}[${y}20${g}] ${p}=> ${b}JexBoss${y}           ${b}(${r}Vulnscanner, requires target${b})${rs}"; sleep 0.2
    printf "${g}[${y}10${g}] ${p}=> ${b}EvilWifi v2${y}[${g}Linux${y}] ${b}(${r}BackTrack Wifi Hack${b})${rs}"; sleep 0.2; echo -e "${g}[${y}21${g}] ${p}=> ${b}Telnet Bruter${y}     ${b}(${r}Bruteforce Telnet, requires Arguments${b})${rs}"; sleep 0.2
    printf "${g}[${y}11${g}] ${p}=> ${b}WhatSpam           (${r}WhatsApp Web Spamming${b})${rs}"; sleep 0.2; echo ""
    printf "${g}[${y}back${g}] ${p}=> ${b}Back To Menu"; sleep 0.2; echo ""
    printf "${g}[${y}exit|e${g}] ${p}=> ${b}Exit Tool"; sleep 0.2; echo ""
    echo ""
    echo -e "${r}[!] NOTE: ${y} Some tools need a wordlist, or any arguments, in most cases it prints only usage"
    
    testt=0
    while [ $testt = 0 ]
    do 
        echo -e "${bd}"
        echo -ne "${r}【 mak3r@root 】${y}/lib/communitytools.sh ${b}~>:${r} "
        read use
        case "$use" in 
            1)
            bash lib/combo_editor.sh
            testt=1
            ;;
            2)
            python3 lib/mysql.py
            testt=1
            ;;
            3)
            python lib/proxy.py
            testt=1
            ;;
            4)
            if [ -d lib/pr0xyscr4p3r ]
            then 
                cd lib/pr0xyscr4p3r; bash proxy.sh
                cd ..; cd ..
            else
                cd lib
                git clone https://github.com/rebl0x3r/pr0xyscr4p3r
                cd pr0xyscr4p3r; bash proxy.sh
                cd ..; cd ..
            fi
            testt=1
            ;;
            5)
            bash lib/ping.sh
            testt=1
            ;;
            6)
            bash lib/insta.sh
            testt=1
            ;;
            7)
            bash lib/pwd.sh
            testt=1
            ;;
            8)
            bash lib/automation.sh
            testt=1
            ;;
            9)
            bash lib/evilwifi.sh
            testt=1
            ;;
            10)
            bash lib/evil.sh
            testt=1
            ;;
            11)
            pip3 install pyautogui
            python3 spam.py
            testt=1
            ;;
            12)
            echo -e "${b}[*] ${r}Run this in windows: ${g}$path/lib/b00t3r.bat"
            testt=1
            ;;
            13)
            python lib/exploit
            testt=1
            ;;
            14)
            python lib/gmail.py
            testt=1
            ;;
            15)
            bash lib/random_mac.sh
            testt=1
            ;;
            16)
            python2 penbox.py
            testt=1
            ;;
            17)
            bash lib/r00tw0rm/RW-launcher.sh
            testt=1
            ;;
            18)
            echo -e "${b}[*] ${r}Run the tools from folder: ${g}$path/lib/ddos/"
            testt=1
            ;;
            19)
            ./lib/ssh
            testt=1
            ;;
            20)
            python lib/jexboss_vulnscanner.py
            testt=1
            ;;
            21)
            python lib/telnet_bruter_loader.py
            ;;
            e)
            exit
            testt=1
            ;;
            exit)
            exit
            testt=1
            ;;
            back)
            if [ -f 4ut0m4t10n.sh ]
            then 
                bash 4ut0m4t10n.sh
            else
                cd ..
                bash 4ut0m4t10n.sh
            fi
            testt=1
            ;;
            *)
		    echo '[!] Wrong command!'
		    sleep 1
		    ;;
        esac
    done

}

main
