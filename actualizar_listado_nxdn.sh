#!/bin/bash
#Colores
ROJO="\033[1;31m"
VERDE="\033[1;32m"
BLANCO="\033[1;37m"
AMARILLO="\033[1;33m"
CIAN="\033[1;36m"
GRIS="\033[0m"
MARRON="\33[38;5;138m"

echo -e "${VERDE}Descargando NXDNHosts.txt...${GRIS}"

cd /home/pi/
wget --user-agent="NXDNGateway" https://hostfiles.refcheck.radio/NXDNHosts.txt

    # Mover el nuevo archivo
    sudo mv /home/pi/NXDNHosts.txt /home/pi/NXDNClients/NXDNGateway/
    
    echo -e "${VERDE}NXDNHosts.txt actualizado correctamente${GRIS}"
    

sleep 3
