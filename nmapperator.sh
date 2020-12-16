#!/bin/bash

# Color for output
GREEN="\e[32m";
END="\e[0m";

# Create directories to save nmap output
SAVE_DIR=$2/nmap
mkdir -p $SAVE_DIR

# Scan all ports
echo -e "$GREEN###########################$END"
echo -e "$GREEN### SCANNING ALL PORTS ####$END"
echo -e "$GREEN###########################$END"
nmap -T4 -v -p- -oA $SAVE_DIR/all-ports-scan $1

# TODO:
# Thinking about implemnting for more than one host
# Grep for hosts
# grep -oR 'Host:.*()' $SAVE_DIR/all-ports.gnmap | awk '/\s/ { print $2 }' | sort -u | tee -a $SAVE_DIR/hosts.txt

# Grep for ports
PORTS=$(grep -oR 'Ports:.*$' $SAVE_DIR/all-ports-scan.gnmap | grep -oE '[0-9]{1,5}/' | sed 's/\///g' | sort -u | tr '\n' ',' | sed 's/,$//g')

# Do basic nmap scan on alive hosts and ports
echo -e "$GREEN###################################$END"
echo -e "$GREEN### DEFAULT SCAN ON OPEN PORTS ####$END"
echo -e "$GREEN###################################$END"
nmap -T4 -v -p $PORTS -sC -sV -oA $SAVE_DIR/default-scan $1

# Do vuln scan on alive hosts and ports
echo -e "$GREEN################################$END"
echo -e "$GREEN### VULN SCAN ON OPEN PORTS ####$END"
echo -e "$GREEN################################$END"
nmap -T4 -v -p $PORTS --script vuln -sV -oA $SAVE_DIR/vuln-scan $1
