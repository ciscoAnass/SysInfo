#!/bin/bash
clear

# Display current system information
echo "System Information - $(date)"
echo "--------------------------------"

# Disk Information
DiskInfo=$(df -hT / | awk 'NR==2 {print $6, $3}')
DiskUsage=$(echo "$DiskInfo" | cut -d " " -f1)
DiskCapacity=$(echo "$DiskInfo" | cut -d " " -f2)

# RAM Information
TotalRam=$(free | awk '/Mem/ {print $2}')
UsedRam=$(free | awk '/Mem/ {print $3}')
RAMUsage=$(awk "BEGIN {printf \"%.2f\", ($UsedRam / $TotalRam) * 100}")

# Swap Information
TotalSwap=$(free | awk '/Swap/ {print $2}')
UsedSwap=$(free | awk '/Swap/ {print $3}')
SwapUsage=$(awk "BEGIN {printf \"%.2f\", ($UsedSwap / $TotalSwap) * 100}")

# Process Information
TotalProcesses=$(ps -e --no-headers | wc -l)
RootProcesses=$(ps -u root --no-headers | wc -l)

# IP Information - Join multiple IPs with "-"
ipv4=$(ip -4 addr show scope global | awk '/inet/ {print $2}' | paste -sd " - ")
ipv6=$(ip -6 addr show scope global | awk '/inet6/ {print $2}' | paste -sd " - ")
ipv4=${ipv4:-"No IPv4 Address"}
ipv6=${ipv6:-"No IPv6 Address"}

# Last System Boot
lastlog=$(last reboot | head -1 | awk '{print $5, $6, $7, $8, $9}')

# Logged Users
LoggedUsers=$(who | awk '{print $1}' | sort | uniq | paste -sd ", " -)

# Last SSH Connection with improved parsing and date formatting
ssh_log=$(grep 'sshd' /var/log/auth.log | grep 'Accepted' | tail -1)
if [ -z "$ssh_log" ]; then
    ssh_info="No SSH Connection"
else
    sshtime=$(echo "$ssh_log" | perl -p -e 's/ {2,}/ /g' | cut -d " " -f1,2,3)
    sshuser=$(echo "$ssh_log" | perl -p -e 's/ {2,}/ /g' | cut -d " " -f9)
    sship=$(echo "$ssh_log" | perl -p -e 's/ {2,}/ /g' | cut -d " " -f11)
    sshport=$(echo "$ssh_log" | perl -p -e 's/ {2,}/ /g' | cut -d " " -f13)
    ssh_info="The last SSH login for user $sshuser was at $sshtime from $sship port $sshport"
fi

# Display System Information
echo "Disk Usage (/):              $DiskUsage of $DiskCapacity"
echo "RAM Usage:                   $RAMUsage%"
echo "Swap Usage:                  $SwapUsage%"
echo "Total Processes:             $TotalProcesses"
echo "Root Processes:              $RootProcesses"
echo "IPv4 Address(es):            $ipv4"
echo "IPv6 Address(es):            $ipv6"
echo "Last System Boot:            $lastlog"
echo "Logged Users:                $LoggedUsers"
echo "$ssh_info"
echo "--------------------------------"
