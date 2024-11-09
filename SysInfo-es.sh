#!/bin/bash
clear

# Mostrar la información del sistema
echo "Información del sistema - $(date)"
echo "--------------------------------"

# Información de Uso del Disco
DiskInfo=$(df -hT / | awk 'NR==2 {print $6, $3}')
DiskPer=$(echo "$DiskInfo" | cut -d " " -f1)
DiskCapacity=$(echo "$DiskInfo" | cut -d " " -f2)

# Información de Uso de la RAM
TotalRam=$(free | awk '/Mem/ {print $2}')
UsedRam=$(free | awk '/Mem/ {print $3}')
UsoRAM=$(awk "BEGIN {printf \"%.2f\", ($UsedRam / $TotalRam) * 100}")

# Información de Uso de Swap
TotalSwap=$(free | awk '/Swap/ {print $2}')
UsedSwap=$(free | awk '/Swap/ {print $3}')
UsoSwap=$(awk "BEGIN {printf \"%.2f\", ($UsedSwap / $TotalSwap) * 100}")

# Información de Procesos
TotalProcesos=$(ps -e --no-headers | wc -l)
ProcesosRoot=$(ps -u root --no-headers | wc -l)

# Información de las IPs (Múltiples IPs separadas por "-")
ipv4=$(ip -4 addr show scope global | awk '/inet/ {print $2}' | paste -sd " - ")
ipv6=$(ip -6 addr show scope global | awk '/inet6/ {print $2}' | paste -sd " - ")
ipv4=${ipv4:-"No hay dirección IPv4"}
ipv6=${ipv6:-"No hay dirección IPv6"}

# Último reinicio del sistema
ultimo_reinicio=$(last reboot | head -1 | awk '{print $5, $6, $7, $8, $9}')

# Usuarios logueados
UsuariosLogueados=$(who | awk '{print $1}' | sort | uniq | paste -sd ", " -)

# Última conexión SSH con formato mejorado
ssh_log=$(grep 'sshd.*Accepted' /var/log/auth.log | tail -1)
if [[ -z "$ssh_log" ]]; then
    ssh_info="Sin conexiones SSH recientes"
else
    # Extraer y formatear los datos de la última conexión SSH
    ssh_fecha=$(echo "$ssh_log" | awk '{print $1, $2, $3}')
    ssh_usuario=$(echo "$ssh_log" | awk '{for(i=1;i<=NF;i++) if($i=="Accepted") print $(i+2)}')
    sship=$(echo "$ssh_log" | awk '{for(i=1;i<=NF;i++) if($i=="from") print $(i+1)}')
    sshpuerto=$(echo "$ssh_log" | awk '{for(i=1;i<=NF;i++) if($i=="port") print $(i+1)}')

    # Verificar y formatear la fecha
    ssh_fecha_formateada=$(date -d "$ssh_fecha" +"%Y-%m-%d %H:%M:%S" 2>/dev/null)
    ssh_fecha_formateada=${ssh_fecha_formateada:-$ssh_fecha}

    # Generar mensaje claro
    ssh_info="Última conexión SSH por el usuario '${ssh_usuario:-desconocido}' el ${ssh_fecha_formateada:-desconocido} desde la IP ${sship:-desconocida} en el puerto ${sshpuerto:-desconocido}"
fi

# Mostrar Información del Sistema
echo "Uso del Disco (/):           $DiskPer de $DiskCapacity"
echo "Uso de la RAM:               $UsoRAM%"
echo "Uso de Swap:                 $UsoSwap%"
echo "Total de Procesos:           $TotalProcesos"
echo "Procesos del Root:           $ProcesosRoot"
echo "Dirección(es) IPv4:          $ipv4"
echo "Dirección(es) IPv6:          $ipv6"
echo "Último reinicio del sistema: $ultimo_reinicio"
echo "Usuarios logueados:          $UsuariosLogueados"
echo "$ssh_info"
echo "--------------------------------"
