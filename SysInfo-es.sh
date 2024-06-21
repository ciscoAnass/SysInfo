#!/bin/bash
clear


#VARIABLES Del Disco

DiskPer=$(df -hT | grep -w "/" | perl -p -e 's/ {2,}/ /g' | cut -d " " -f6)
DiskCapacity=$(df -hT | grep -w "/" | perl -p -e 's/ {2,}/ /g' | cut -d " " -f3)

#VARIABLES del RAM
TotalRam=$(free | perl -p -e 's/ {2,}/ /g' | grep "Mem" | cut -d " " -f2)
UsedRam=$(free | perl -p -e 's/ {2,}/ /g' | grep "Mem" | cut -d " " -f3)
RAM=$(echo "scale=3; ($UsedRam / $TotalRam) * 100" | bc)


#VARIABLES de los SWAP
TotalSwap=$(free | perl -p -e 's/ {2,}/ /g' | grep "Swap" | cut -d " " -f2)
UsedSwap=$(free | perl -p -e 's/ {2,}/ /g' | grep "Swap" | cut -d " " -f3)
Swap=$(echo "scale=3; ($UsedSwap / $TotalSwap) * 100" | bc)


#VARIABLES de los Procesos
Pro=$(ps aux | wc -l )
Processes=$(echo "scale=3; $Pro - 1" | bc)
RootProcesses=$(ps aux | cut -d " " -f1 | grep "root" | wc -l)

#Variables Los Ip
ipv4=$(ip -4 addr show | grep -v "127.0.0.1" | grep "inet" | cut -d " " -f6 )
if [ -z "$ipv4" ]; then
    ipv4="No IPv4 Address"
fi

ipv6=$(hostname -I | cut -d " "  -f2)
if [ -z "$ipv6" ]; then
    ipv6="No IPv6 Address"
fi
#Variables Lde la Ultima Conexion
lastlog=$(last down | cut -d " " -f3,4,5,6,7 | tail -1)

# Variables de los usuarios logueados
LoggedUsers=$(who | cut -d " " -f1)


# VARIABLES del SSH
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

#Menu

echo "Información del sistema de $(date)"
echo "                                                   "
echo "Uso Del / :                 $DiskPer of $DiskCapacity "
echo "Uso de memoria :            $RAM% "
echo "Uso de Swap :               $Swap%"
echo "Procesos Totales :          $Processes"
echo "Procesos del Root :         $RootProcesses"
echo "Dirección IPv4 :            $ipv4     "
echo "Dirección IPv6 :            $ipv6     "
echo "Último Acceso :             $lastlog"
echo "                                                   "

echo "$ssh_info"

echo "                                                   "
echo "Usuarios lOGUEADOS :           $LoggedUsers "
