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

clear

function main {
    printf '\e[8;33;100t'
    echo -e "${rs}
${ob}${bd} ▄▄   ▄▄ ▄▄▄ ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄ ▄▄▄▄▄▄   ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄ ▄▄▄▄▄▄   ▄▄▄▄▄▄▄ ▄     ▄ ${rs}
${ob}${bd}█  █ █  █   █       █       █   ▄  █ █       █       █   ▄  █ █       █ █ ▄ █ █${rs}
${ob}${bd}█  █▄█  █   █    ▄  █    ▄▄▄█  █ █ █ █▄▄▄▄   █       █  █ █ █ █    ▄▄▄█ ██ ██ █${rs}
${ob}${bd}█       █   █   █▄█ █   █▄▄▄█   █▄▄█▄ ▄▄▄▄█  █     ▄▄█   █▄▄█▄█   █▄▄▄█       █${rs}
${ob}${bd}█       █   █    ▄▄▄█    ▄▄▄█    ▄▄  █ ▄▄▄▄▄▄█    █  █    ▄▄  █    ▄▄▄█       █${rs}
${ob}${bd} █     ██   █   █   █   █▄▄▄█   █  █ █ █▄▄▄▄▄█    █▄▄█   █  █ █   █▄▄▄█   ▄   █${rs}
${ob}${bd}  █▄▄▄█ █▄▄▄█▄▄▄█   █▄▄▄▄▄▄▄█▄▄▄█  █▄█▄▄▄▄▄▄▄█▄▄▄▄▄▄▄█▄▄▄█  █▄█▄▄▄▄▄▄▄█▄▄█ █▄▄█${rs}
${rs}
${or}by @ViperZCrew${rs}                                        ${op}collected by @TheMasterCH${rs}
${og}GitHub${rs}                                                ${og}https://github.com/0n1c0n3${rs} ${y}(originally rebl0x3r)${rs}
${oy}Directory:${rs}                                            ${oy}$path${rs}
      

                     ${p}${og}.${rs}                          
                     ${p}${og}M${rs}                          
                    ${p}${og}dM${rs}                          
                    ${p}${og}MMr${rs}                         
                   ${p}${og}4MMML${rs}                  ${p}${og}.${rs}     
                   ${p}${og}MMMMM.${rs}                ${p}${og}xf${rs}     
   ${p}${og}.${rs}              ${p}${og}'MMMMM${rs}               ${p}${og}.MM-${rs}     ${w}${or}All what we want,${rs}
    ${p}${og}Mh..${rs}          ${p}${og}+MMMMMM${rs}            ${p}${og}.MMMM${rs}    ${w}${or}Is another weed,${rs}
    ${p}${og}.MMM.${rs}         ${p}${og}.MMMMML.${rs}          ${p}${og}MMMMMh${rs}  ${w}${or}Who-ooh!${rs}
     ${p}${og})MMMh.${rs}        ${p}${og}MMMMMM${rs}         ${p}${og}MMMMMMM${rs}       
      ${p}${og}3MMMMx.${rs}     ${p}${og}'MMMMMMf${rs}      ${p}${og}xnMMMMMM'${rs}       
      ${p}${og}'*MMMMM${rs}      ${p}${og}MMMMMM.${rs}     ${p}${og}nMMMMMMP'${rs}        
        ${p}${og}*MMMMMx${rs}    ${p}${og}'MMMMM|${rs}    ${p}${og}.MMMMMMM=${rs}         
         ${p}${og}*MMMMMh${rs}   ${p}${og}'MMMMM'${rs}  ${p}${og}JMMMMMMP${rs}           
           ${p}${og}MMMMMM${rs}   ${p}${og}3MMMM.${rs}  ${p}${og}dMMMMMM${rs}           ${p}${og}_.${rs}
            ${p}${og}MMMMMM${rs}  ${p}${og}'MMMM${rs}  ${p}${og}.MMMMM(${rs}        ${p}${og}.nnMP'${rs}
${p}${og}=..${rs}          ${p}${og}*MMMMx${rs}  ${p}${og}MMM'${rs}  ${p}${og}dMMMM'${rs}    ${p}${og}.nnMMMMM*${rs}  
  ${p}${og}'MMn...${rs}     ${p}${og}'MMMMr${rs}  ${p}${og}'MM${rs}   ${p}${og}MMM'${rs}   ${p}${og}.nMMMMMMM*'${rs}   
   ${p}${og}'4MMMMnn..${rs}    ${p}${og}*MMM${rs}  ${p}${og}MM${rs}  ${p}${og}MMP'${rs}   ${p}${og}.dMMMMMMM''${rs}     
     ${p}${og}^MMMMMMMMx.${rs}   ${p}${og}*ML 'M .M*${rs}   ${p}${og}.MMMMMM**'${rs}        
        ${p}${og}*PMMMMMMhn.${rs}   ${p}${og}*x > M  .MMMM**''${rs}           
           ${p}${og}''**MMMMhx/.h/ .=*'${rs}                  
                    ${p}${og}.3P'%....${rs}                   
                  ${p}${og}nP'${rs}     ${p}${og}'*MMnx${rs}       
    

    "
sleep 0.5
printf "${c}[${w}1${c}] => ${r}Install AndroBug ${p}         - Check Apps For Vuln.                     ${g}[NO-ROOT]"
echo ""
sleep 0.1
printf "${c}[${w}2${c}] => ${r}Install BlackHydra ${p}       - Brute Force Tool.                        ${g}[NO-ROOT]"
echo ""
sleep 0.1
printf "${c}[${w}3${c}] => ${r}Install Breacher ${p}         - Admin Panel Finder.                      ${g}[NO-ROOT]"
echo ""
sleep 0.1
printf "${c}[${w}4${c}] => ${r}Install Brutedum ${p}         - Brute Force SSH,FTP Telnet etc.          ${g}[NO-ROOT]"
echo ""
sleep 0.1
printf "${c}[${w}5${c}] => ${r}Install Gloom Framework ${p}  - Open-Source Security Framework.          ${r}[ROOT]"
echo ""
sleep 0.1
printf "${c}[${w}6${c}] => ${r}Install Httrack ${p}          - Website Clone Toolkit.                   ${r}[ROOT]"
echo ""
sleep 0.1
printf "${c}[${w}7${c}] => ${r}Install Nikto   ${p}          - Vulnerability Scanner                    ${g}[NO-ROOT]"
echo ""
sleep 0.1
printf "${c}[${w}8${c}] => ${r}Install Optiva Framework ${p} - Web Application Scanner                  ${g}[NO-ROOT]"
echo ""
sleep 0.1
printf "${c}[${w}9${c}] => ${r}Install RedHawk ${p}          - Information Gathering Tool               ${g}[NO-ROOT]"
echo ""
sleep 0.1
printf "${c}[${w}10${c}] => ${r}Install TheHarverst ${p}     - E-Mails, Subdomains and Names Gathering  ${g}[NO-ROOT]"
echo ""
sleep 0.1
printf "${c}[${w}11${c}] => ${r}Install WeeMan ${p}          - A Little Phishing Tool                   ${g}[NO-ROOT]"
echo ""
sleep 0.1
printf "${c}[${w}12${c}] => ${r}Install WPScan ${p}          - Wordpress Vulnerability Scanner          ${y}[NO-ROOT/ROOT]"
echo ""
sleep 0.1
printf "${c}[${w}13${c}] => ${r}Install Tool-X ${p}          - Advanced Hack Tools Installer            ${g}[NO-ROOT]"
echo ""
sleep 0.1
printf "${c}[${w}14${c}] => ${r}Install ReckZ ${p}           - DDoS Perl Flood Script                   ${g}[NO-ROOT]"
echo ""
sleep 0.1
printf "${c}[${w}15${c}] => ${r}Install Tool Installer ${p}  - A Indonesian Cyber Tool Collection       ${g}[NO-ROOT]"
echo ""
sleep 0.1
printf "${c}[${w}16${c}] => ${r}Malicious Tool ${p}          - Create Virus                             ${g}[NO-ROOT]"
echo ""
sleep 0.1
printf "${c}[${w}17${c}] => ${r}Torshammer ${p}              - Launch DDoS Attack Over Tor              ${g}[NO-ROOT]"
echo ""
sleep 0.1
printf "${c}[${w}18${c}] => ${r}Hulk ${p}                    - A Strong DoS Tool                        ${g}[NO-ROOT]"
echo ""
sleep 0.1
printf "${c}[${w}19${c}] => ${r}Lazyscript ${p}              - Tool For Noobs                           ${g}[NO-ROOT]"
echo ""
sleep 0.1
printf "${c}[${w}20${c}] => ${r}TM-Scanner ${p}              - Termux Website Vulnerability Scanner     ${y}[NO-ROOT/ROOT]"
echo ""
sleep 0.1
printf "${c}[${w}21${c}] => ${r}Fsociety ${p}                - A Penetration Testing Framework          ${y}[NO-ROOT/ROOT]"
echo ""
sleep 0.1
printf "${c}[${w}22${c}] => ${r}A-Rat ${p}                   - Remote Administration Tools              ${y}[NO-ROOT/ROOT]"
echo ""
sleep 0.1
printf "${c}[${w}23${c}] => ${r}Angry-Fuzzer ${p}            - Collectoin(I-Gathering & Vuln Finder)    ${y}[NO-ROOT/ROOT]"
echo ""
sleep 0.1
printf "${c}[${w}24${c}] => ${r}Hasher ${p}                  - Hash Cracker                             ${y}[NO-ROOT/ROOT]"
echo ""
sleep 0.1
printf "${c}[${w}25${c}] => ${r}Hunner ${p}                  - Bruteforce Tool (FTP,SSH...)             ${y}[NO-ROOT/ROOT]"
echo ""
sleep 0.1
printf "${c}[${w}26${c}] => ${r}T-Bomb ${p}                  - Worldwide SMS & Call Bomber              ${y}[NO-ROOT/ROOT]"
echo ""
sleep 0.1
printf "${c}[${w}27${c}] => ${r}IPGeoLocation ${p}           - IP Tracer                                ${y}[NO-ROOT/ROOT]"
echo ""
sleep 0.1
printf "${c}[${w}28${c}] => ${r}Nmap Automator ${p}          - Nmap Automation Script                   ${y}[NO-ROOT/ROOT]"
echo ""
sleep 0.1
printf "${c}[${w}menu${c}] => ${r}Back To 4ut0m4t10n"
echo ""
sleep 0.1
printf "${c}[${w}exit|e${c}] => ${r}Exit"
echo ""


sleep 0.5
    tools=0
    while [ $tools = 0 ]
    do
        echo -e ""
        echo -ne "${w}┌─${y}【 ${r}viperzcrew${w}@${b}root ${y}】${r}[${c}✠${r}]
${w}└─╼ ${r}$ ${c}: "
        read ex
        case "$ex" in
            1)
            clear
            echo -ne "${b}[${r}>${b}] ${p}Press enter to start> "
            read enter
            sleep 1
            echo -e "\n${g}[i] ${b}Installing ${r}AndroBugs${b}...\n"
            sleep 0.5
            git clone https://github.com/AndroBugs/AndroBugs_Framework; cd AndroBugs_Framework; apt install python2; chmod +x *; cd ..
            sleep 1
            echo -e "\n${g}[i] ${b}Successfully installed ${r}AndroBugs.\n"
            echo -e "${g}[i] ${b}To start type: ${r}python2 androbugs.py -f app.apk -o result.txt"
            echo -ne "${b}[${r}>${b}] ${p}Press enter to go back> "
            main
            tools=1
            ;;
            2)
            clear
            echo -ne "${b}[${r}>${b}] ${p}Press enter to start> "
            read enter
            sleep 1
            echo -e "\n${g}[i] ${b}Installing ${r}BlackHydra${b}...\n"
            sleep 0.5
            git clone https://github.com/Gameye98/Black-Hydra; cd Black-Hydra && chmod +rwx blackhydra.py; cd ..
            sleep 1
            echo -e "\n${g}[i] ${b}Successfully installed ${r}BlackHydra.\n"
            echo -e "${g}[i] ${b}To start type: ${r}python2 blackhydra.py"
            echo -ne "${b}[${r}>${b}] ${p}Press enter to go back> "
            main
            tools=1
            ;;
            3)
            clear
            echo -ne "${b}[${r}>${b}] ${p}Press enter to start> "
            read enter
            sleep 1
            echo -e "\n${g}[i] ${b}Installing ${r}Breacher${b}...\n"
            sleep 0.5
            git clone https://github.com/s0md3v/Breacher
            sleep 1
            echo -e "\n${g}[i] ${b}Successfully installed ${r}Breacher.\n"
            echo -e "${g}[i] ${b}To start type: ${r}python2 breacher.py"
            echo -ne "${b}[${r}>${b}] ${p}Press enter to go back> "
            main
            tools=1
            ;;
            4)
            clear
            echo -ne "${b}[${r}>${b}] ${p}Press enter to start> "
            read enter
            sleep 1
            echo -e "\n${g}[i] ${b}Installing ${r}BruteDum${b}...\n"
            sleep 0.5
            pkg install hydra; git clone https://github.com/GitHackTools/BruteDum; cd BruteDum; chmod +x *; cd ..
            sleep 1
            echo -e "\n${g}[i] ${b}Successfully installed ${r}BruteDum.\n"
            echo -e "${g}[i] ${b}To start type: ${r}python3 brutedum.py"
            echo -ne "${b}[${r}>${b}] ${p}Press enter to go back> "
            main 
            tools=1
            ;;
            5)
            clear
            echo -ne "${b}[${r}>${b}] ${p}Press enter to start> "
            read enter
            sleep 1
            echo -e "\n${g}[i] ${b}Installing ${r}Gloom${b}...\n"
            sleep 0.5
            apt install nmap python2 python tsu -y; git clone https://github.com/StreetSec/Gloom-Framework.git; cd Gloom-Framework; chmod +x *; pip2 install requests; cd ..
            sleep 1
            echo -e "\n${g}[i] ${b}Half installed, go into folder and run: ${r}tsu\n"
            echo -e "${g}[i] ${b}To finish installation: ${r}python2 install.py && python2 gloom.py"
            echo -ne "${b}[${r}>${b}] ${p}Press enter to go back> "
            main
            tools=1
            ;;
            6)
            clear
            echo -ne "${b}[${r}>${b}] ${p}Press enter to start> "
            read enter
            sleep 1
            echo -e "\n${g}[i] ${b}Installing ${r}Httrack${b}...\n"
            sleep 0.5
            apt install curl -y; curl -LO https://raw.githubusercontent.com/Hax4us/httrack_In_termux/master/httrack; chmod +x httrack
            echo -e "\n${g}[i] ${b}Successfully installed ${r}httrack.\n"
            echo -e "${g}[i] ${b}To start type: ${r}./httrack"
            echo -ne "${b}[${r}>${b}] ${p}Press enter to go back> "
            main
            tools=1
            ;;
            7)
            clear
            echo -ne "${b}[${r}>${b}] ${p}Press enter to start> "
            read enter
            sleep 1
            echo -e "\n${g}[i] ${b}Installing ${r}Nikto${b}...\n"
            sleep 0.5
            apt install perl; git clone https://github.com/sullo/nikto; chmod +x nikto;
            echo -e "\n${g}[i] ${b}Successfully installed ${r}nikto.\n"
            echo -e "${g}[i] ${b}To start type: ${r}perl nikto.pl -h ip -ssl"
            echo -ne "${b}[${r}>${b}] ${p}Press enter to go back> "
            main
            tools=1
             ;;
            8)
            clear
            echo -ne "${b}[${r}>${b}] ${p}Press enter to start> "
            read enter
            sleep 1
            echo -e "\n${g}[i] ${b}Installing ${r}Optiva Framework${b}...\n"
            sleep 0.5
            git clone https://github.com/joker25000/Optiva-Framework; cd Optiva-Framework; chmod +rwx *; bash installer.sh; cd ..
            echo -e "\n${g}[i] ${b}Successfully installed ${r}Optiva-Framework.\n"
            echo -e "${g}[i] ${b}To start type: ${r}python2 optiva.py"
            echo -ne "${b}[${r}>${b}] ${p}Press enter to go back> "
            main
            tools=1
            ;;
            9)
            clear
            echo -ne "${b}[${r}>${b}] ${p}Press enter to start> "
            read enter
            sleep 1
            echo -e "\n${g}[i] ${b}Installing ${r}RedHawk${b}...\n"
            sleep 0.5
            pkg install php -y; git clone https://github.com/Tuhinshubhra/RED_HAWK; chmod +x RED_HAWK
            echo -e "\n${g}[i] ${b}Successfully installed ${r}RedHawk.\n"
            echo -e "${g}[i] ${b}To start type: ${r}php rhawk.php"
            echo -ne "${b}[${r}>${b}] ${p}Press enter to go back> "
            main
            tools=1
            ;;
            10)
            clear
            echo -ne "${b}[${r}>${b}] ${p}Press enter to start> "
            read enter
            sleep 1
            echo -e "\n${g}[i] ${b}Installing ${r}TheHarvester${b}...\n"
            sleep 0.5
            git clone https://github.com/laramies/theHarvester; cd theHarvester && chmod +rwx *; pip3 install -r requirements.txt; python3 setup.py; cd ..
            echo -e "\n${g}[i] ${b}Successfully installed ${r}TheHarvester.\n"
            echo -e "${g}[i] ${b}To start type: ${r}python3 theHarvester.py -d site.com -b google"
            echo -ne "${b}[${r}>${b}] ${p}Press enter to go back> "
            main
            tools=1
            ;;
            11)
            clear
            echo -ne "${b}[${r}>${b}] ${p}Press enter to start> "
            read enter
            sleep 1
            echo -e "\n${g}[i] ${b}Installing ${r}Weeman${b}...\n"
            sleep 0.5
            git clone https://github.com/evait-security/weeman; chmod +x weeman
            echo -e "\n${g}[i] ${b}Successfully installed ${r}Weeman.\n"
            echo -e "${g}[i] ${b}To start type: ${r}python2 weeman.py"
            echo -ne "${b}[${r}>${b}] ${p}Press enter to go back> "
            main
            tools=1
            ;;
            12)
            clear
            echo -ne "${b}[${r}>${b}] ${p}Press enter to start> "
            read enter
            sleep 1
            echo -e "\n${g}[i] ${b}Installing ${r}WPScan${b}...\n"
            sleep 0.5
            pkg install git ruby -y; git clone https://github.com/wpscanteam/wpscan;  cd wpscan && chmod 777 *; gem install bundle; bundle install -j5; cd ..
            echo -e "\n${g}[i] ${b}Successfully installed ${r}WPScan.\n"
            echo -e "${g}[i] ${b}To start type: ${r}ruby wpscan.rb --url website.com"
            echo -ne "${b}[${r}>${b}] ${p}Press enter to go back> "
            main
            tools=1
            ;;
            13)
            clear
            echo -ne "${b}[${r}>${b}] ${p}Press enter to start> "
            read enter
            sleep 1
            echo -e "\n${g}[i] ${b}Installing ${r}Tool-X${b}...\n"
            sleep 0.5
            git clone https://github.com/Rajkumrdusad/Tool-X.git; cd Tool-X; chmod +x install.aex; cd ..
            echo -e "\n${g}[i] ${b}Successfully installed ${r}Tool-X.\n"
            echo -e "${g}[i] ${b}To start type: ${r}toolx"
            echo -ne "${b}[${r}>${b}] ${p}Press enter to go back> "
            main
            tools=1
            ;;
            14)
            clear
            echo -ne "${b}[${r}>${b}] ${p}Press enter to start> "
            read enter
            sleep 1
            echo -e "\n${g}[i] ${b}Installing ${r}ReckZ${b}...\n"
            sleep 0.5
            wget -O reckz.pl https://pastebin.com/5gaML2Qj
            echo -e "\n${g}[i] ${b}Successfully installed ${r}ReckZ.\n"
            echo -e "${g}[i] ${b}To start type: ${r}perl reckz.pl <ip> <port> <packet_size> <time>"
            echo -ne "${b}[${r}>${b}] ${p}Press enter to go back> "
            main
            tools=1
            ;;
            15)
            clear
            echo -ne "${b}[${r}>${b}] ${p}Press enter to start> "
            read enter
            sleep 1
            echo -e "\n${g}[i] ${b}Installing ${r}Tools Installer${b}...\n"
            sleep 0.5
            git clone https://github.com/TUANB4DUT/TOOLSINSTALLERv3; pip install lolcat
            echo -e "\n${g}[i] ${b}Successfully installed ${r}Tools Installer.\n"
            echo -e "${g}[i] ${b}To start type: ${r}bash TUANB4DUT.sh"
            echo -ne "${b}[${r}>${b}] ${p}Press enter to go back> "
            main
            tools=1
            ;;
            16)
            clear
            echo -ne "${b}[${r}>${b}] ${p}Press enter to start> "
            read enter
            sleep 1
            echo -e "\n${g}[i] ${b}Installing ${r}Malicious Tool${b}...\n"
            sleep 0.5
            git clone https://github.com/d3L3t3dOn3/Malicious; cd Malicious; unzip Malicious.zip; cd Malicious pip2 install -r requirements.txt; pip2 install requests; pip install lolcat; chmod +x malicious.py; cd ..; cd ..
            echo -e "\n${g}[i] ${b}Successfully installed ${r}Malicious Tool.\n"
            echo -e "${g}[i] ${b}To start type: ${r}python2 malicious.py"
            echo -ne "${b}[${r}>${b}] ${p}Press enter to go back> "
            main
            tools=1
            ;;
            17)
            clear
            echo -ne "${b}[${r}>${b}] ${p}Press enter to start> "
            read enter
            sleep 1
            echo -e "\n${g}[i] ${b}Installing ${r}Torshammer${b}...\n"
            sleep 0.5
            apt install clang -y; git clone https://github.com/dotfighter/torshammer; chmod +x torshammer
            echo -e "\n${g}[i] ${b}Successfully installed ${r}Torshammer.\n"
            echo -e "${g}[i] ${b}To start type: ${r}./torshammer -t 127.0.0.1 -r 256"
            echo -ne "${b}[${r}>${b}] ${p}Press enter to go back> "
            main
            tools=1
            ;;
            18)
            clear
            echo -ne "${b}[${r}>${b}] ${p}Press enter to start> "
            read enter
            sleep 1
            echo -e "\n${g}[i] ${b}Installing ${r}Hulk${b}...\n"
            sleep 0.5
            git clone https://github.com/grafov/hulk; chmod +x hulk
            echo -e "\n${g}[i] ${b}Successfully installed ${r}Hulk.\n"
            echo -e "${g}[i] ${b}To start type: ${r}python hulk.py <url>"
            echo -ne "${b}[${r}>${b}] ${p}Press enter to go back> "
            main
            tools=1
            ;;
            19)
            clear
            echo -ne "${b}[${r}>${b}] ${p}Press enter to start> "
            read enter
            sleep 1
            echo -e "\n${g}[i] ${b}Installing ${r}Lazyscript${b}...\n"
            sleep 0.5
            git clone https://github.com/TechnicalMujeeb/Termux-Lazyscript.git; chmod +x Termux-Lazyscript; cd Termux-Lazyscript; bash setup.sh; cd ..
            echo -e "\n${g}[i] ${b}Successfully installed ${r}Lazyscript.\n"
            echo -e "${g}[i] ${b}To start type: ${r}python2 ls.py"
            echo -ne "${b}[${r}>${b}] ${p}Press enter to go back> "
            main
            tools=1
            ;;
            20)
            clear
            echo -ne "${b}[${r}>${b}] ${p}Press enter to start> "
            read enter
            sleep 1
            echo -e "\n${g}[i] ${b}Installing ${r}TM-Scanner${b}...\n"
            sleep 0.5
            git clone https://github.com/TechnicalMujeeb/TM-scanner.git; cd TM-scanner; chmod +x *; bash install.sh; cd ..
            echo -e "\n${g}[i] ${b}Successfully installed ${r}TM-Scanner.\n"
            echo -e "${g}[i] ${b}To start type: ${r}python2 tmscanner.py"
            echo -ne "${b}[${r}>${b}] ${p}Press enter to go back> "
            main
            tools=1
            ;;
            21)
            clear
            echo -ne "${b}[${r}>${b}] ${p}Press enter to start> "
            read enter
            sleep 1
            echo -e "\n${g}[i] ${b}Installing ${r}Fsociety${b}...\n"
            sleep 0.5
            git clone https://github.com/Manisso/fsociety.git; pip2 install requests; chmod +x fsociety
            echo -e "\n${g}[i] ${b}Successfully installed ${r}Fsociety.\n"
            echo -e "${g}[i] ${b}To start type: ${r}python2 fsociety.py"
            echo -ne "${b}[${r}>${b}] ${p}Press enter to go back> "
            main
            tools=1
            ;;
            22)
            clear
            echo -ne "${b}[${r}>${b}] ${p}Press enter to start> "
            read enter
            sleep 1
            echo -e "\n${g}[i] ${b}Installing ${r}A-Rat${b}...\n"
            sleep 0.5
            git clone https://github.com/RexTheGod/A-Rat; chmod +x A-Rat
            echo -e "\n${g}[i] ${b}Successfully installed ${r}A-Rat.\n"
            echo -e "${g}[i] ${b}To start type: ${r}python A-Rat.py"
            echo -ne "${b}[${r}>${b}] ${p}Press enter to go back> "
            main
            tools=1
            ;;
            23)
            clear
            echo -ne "${b}[${r}>${b}] ${p}Press enter to start> "
            read enter
            sleep 1
            echo -e "\n${g}[i] ${b}Installing ${r}Angry-Fuzzer${b}...\n"
            sleep 0.5
            git clone https://github.com/ihebski/angryFuzzer.git; chmod +x angryFuzzer
            echo -e "\n${g}[i] ${b}Successfully installed ${r}Angry-Fuzzer.\n"
            echo -e "${g}[i] ${b}To start type: ${r}python angryFuzzer.py"
            echo -ne "${b}[${r}>${b}] ${p}Press enter to go back> "
            main
            tools=1
            ;;
            24)
            clear
            echo -ne "${b}[${r}>${b}] ${p}Press enter to start> "
            read enter
            sleep 1
            echo -e "\n${g}[i] ${b}Installing ${r}Hasher${b}...\n"
            sleep 0.5
            git clone https://github.com/ciku370/hasher; chmod +x hasher
            echo -e "\n${g}[i] ${b}Successfully installed ${r}Hasher.\n"
            echo -e "${g}[i] ${b}To start type: ${r}python2 hash.py"
            echo -ne "${b}[${r}>${b}] ${p}Press enter to go back> "
            main
            tools=1
            ;;
            25)
            clear
            echo -ne "${b}[${r}>${b}] ${p}Press enter to start> "
            read enter
            sleep 1
            echo -e "\n${g}[i] ${b}Installing ${r}Hunner${b}...\n"
            sleep 0.5
            git clone https://github.com/b3-v3r/Hunner; chmod +x Hunner
            echo -e "\n${g}[i] ${b}Successfully installed ${r}Hunner.\n"
            echo -e "${g}[i] ${b}To start type: ${r}python3 hunner.py"
            echo -ne "${b}[${r}>${b}] ${p}Press enter to go back> "
            main
            tools=1
            ;;
            26)
            clear
            echo -ne "${b}[${r}>${b}] ${p}Press enter to start> "
            read enter
            sleep 1
            echo -e "\n${g}[i] ${b}Installing ${r}TBomb${b}...\n"
            sleep 0.5
            git clone https://github.com/TheSpeedX/TBomb.git; chmod TBomb
            echo -e "\n${g}[i] ${b}Successfully installed ${r}TBomb.\n"
            echo -e "${g}[i] ${b}To start type: ${r}bash TBomb.sh"
            echo -ne "${b}[${r}>${b}] ${p}Press enter to go back> "
            main
            tools=1
            ;;
            27)
            clear
            echo -ne "${b}[${r}>${b}] ${p}Press enter to start> "
            read enter
            sleep 1
            echo -e "\n${g}[i] ${b}Installing ${r}IPGeoLocation${b}...\n"
            sleep 0.5
            git clone https://github.com/maldevel/IPGeoLocation; cd IPGeoLocation; pip3 install -r requirements.txt; cd ..
            echo -e "\n${g}[i] ${b}Successfully installed ${r}IPGeoLaction.\n"
            echo -e "${g}[i] ${b}To start type: ${r}./ip2geolocation.py"
            echo -ne "${b}[${r}>${b}] ${p}Press enter to go back> "
            main
            tools=1
            ;;
            28)
            clear
            echo -ne "${b}[${r}>${b}] ${p}Press enter to start> "
            read enter
            sleep 1
            echo -e "\n${g}[i] ${b}Installing ${r}Nmap Automator${b}...\n"
            sleep 0.5
            git clone https://github.com/21y4d/nmapAutomator; chmod nmapAutomator
            echo -e "\n${g}[i] ${b}Successfully installed ${r}Nmap Automator.\n"
            echo -e "${g}[i] ${b}To start type: ${r}./nmapAutomator.sh"
            echo -ne "${b}[${r}>${b}] ${p}Press enter to go back> "
            main
            tools=1
            ;;
            e)
            exit
            tools=1
            ;;
            exit)
            exit
            tools=1
            ;;
            menu)
            if [ -f 4ut0m4t10n.sh ]
            then 
                bash 4ut0m4t10n.sh
            else
                cd ..
                bash 4ut0m4t10n.sh
            fi
            tools=1
            ;;
            *)
            echo -e "${r}N00b! ${b} INVALID COMMAND ${r}!"
            tools=0
            ;;
        esac
    done
}


main
