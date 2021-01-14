#!/bin/bash

# Color for output
GREEN="\e[32m";
END="\e[0m";

# argv[1] is the domain for the script
DOMAIN=$2
OUTPUT_DIR=$1

if [[ "$#" -ne 2 ]]
then
	echo -e "Usage: $0 <directory> <ip|domain>"
	exit 1
fi

# Check if root
if [[ $EUID -ne 0 ]]
then
	echo -e "$INVERTED$BLINK$RED$BOLD[!] You are not root...$END$END$END$END"
	echo -e "Usage: $0 <directory> <ip|domain>"
	exit 1
fi

# Create directories to save output to
# if it doesn't already exist
if [ ! -d "$OUTPUT_DIR" ]; then
	mkdir $OUTPUT_DIR
fi

# Scan all ports
echo -e "$GREEN##########################$END"
echo -e "$GREEN### SCANNING ALL PORTS ###$END"
echo -e "$GREEN##########################$END"
nmap -v -p0-65535 -oA $OUTPUT_DIR/all-ports-scan $DOMAIN

# Grep for ports
PORTS=$(grep -ioE '[0-9]{1,5}/[a-z]+' $OUTPUT_DIR/all-ports-scan.gnmap | awk -F'/' '{ print $1 }' | tr '\n' ',' | sed 's/,$//g')

# Do default nmap script scan on alive hosts and ports
echo -e "$GREEN##################################$END"
echo -e "$GREEN### DEFAULT SCAN ON OPEN PORTS ###$END"
echo -e "$GREEN##################################$END"
nmap -v -p$PORTS -sC -sV -oA $OUTPUT_DIR/default-scan $DOMAIN

# Do vuln scan on alive hosts and ports
echo -e "$GREEN###############################$END"
echo -e "$GREEN### VULN SCAN ON OPEN PORTS ###$END"
echo -e "$GREEN###############################$END"
nmap -v -p $PORTS --script vuln -sV -oA $OUTPUT_DIR/vuln-scan $DOMAIN
