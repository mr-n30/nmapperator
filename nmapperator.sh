#!/bin/bash

# Create directories to save nmap output
SAVE_DIR=Targets/$2/nmap
mkdir -p $SAVE_DIR

# Scan all ports
nmap -T4 -v -p- -oA $SAVE_DIR/all-ports $1

# TODO:
# Thinking about implemnting for more than one host
# Grep for hosts
# grep -oR 'Host:.*()' $SAVE_DIR/all-ports.gnmap | awk '/\s/ { print $2 }' | sort -u | tee -a $SAVE_DIR/hosts.txt

# Grep for ports
PORTS=$(grep -oR 'Ports:.*$' $SAVE_DIR/all-ports.gnmap | grep -oE '[0-9]{1,5}/' | sed 's/\///g' | sort -u | tr '\n' ',' | sed 's/,$//g')

# Do basic nmap scan on alive hosts and ports
nmap -T4 -v -p $PORTS -sC -sV -oA $SAVE_DIR/default-scan $1
