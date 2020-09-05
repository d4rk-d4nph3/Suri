#!/bin/bash 

###################################################################
# Script Name	: GenerateAnalytics.sh                                                                                         
# Description	: Generates Analytics from Suricata Logs                                                                                                                                                       
# Author       	: d4rk-d4nph3
# Created At    : Sep 5, 2020
# Version       : 0.1
# Remark        : Performance NOT tested on large log files                         
###################################################################

LOG_DIR=$(suricata --dump-config | grep 'log-dir' | grep -o '/.*')

cd $LOG_DIR

# Using tput to change text color during echo
# 2 is green
# 4 is blue
# 5 is mangenta

tput setaf 1; echo "Top 10 Alerts"; tput setaf 5
cat eve.json | jq '. | select(.event_type == "alert") | .alert.signature' | sort | uniq -c | sort -nr | head -10 | tr -d '"'
echo

tput setaf 4; echo "Top 10 DNS Queries"; tput setaf 2
cat eve.json | jq '. | select(.event_type == "dns") | .dns.rrname' | sort | uniq -c | sort -nr | head -10 | tr -d '"'
echo

tput setaf 4; echo "NXDOMAIN DNS Queries"; tput setaf 2
cat eve.json | jq 'select(.dns.rcode == "NXDOMAIN") | .dns.rrname' | sort | uniq -u | tr -d '"'
echo

tput setaf 4; echo "Top 10 Destination IPs"; tput setaf 2
cat eve.json | jq -c 'select(.event_type=="flow") | [.dest_ip]' | sort | uniq -c | sort -nr | head -10 | tr -d '"[]'
echo

tput setaf 4; echo "Top 10 Destination Ports"; tput setaf 2
cat eve.json | jq -c 'select(.event_type=="flow") | [.proto, .dest_port]' | sort | uniq -c | sort -nr | head -10 | tr -d '"[]'
echo

tput setaf 4; echo "Top 10 Source IPs"; tput setaf 2
cat eve.json | jq -c 'select(.event_type=="flow") | [.proto, .src_ip]' | sort | uniq -c | sort -nr | head -10 | tr -d '"[]'
echo 

tput setaf 4; echo "Top 10 User Agents"; tput setaf 2
cat eve.json | jq '. | select(.event_type == "http") | .http.http_user_agent' | sort | uniq -u | sort -nr | head -10 | tr -d '"'
echo

tput setaf 4; echo "Top 10 Least Common User Agents"; tput setaf 2
cat eve.json | jq '. | select(.event_type == "http") | .http.http_user_agent' | sort | uniq -u | sort -nr | tail -10 | tr -d '"'
echo
