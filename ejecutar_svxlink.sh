#!/bin/bash
#Colores 
ROJO="\033[1;31m"
VERDE="\033[1;32m"
BLANCO="\033[1;37m"
AMARILLO="\033[1;33m"
CIAN="\033[1;36m"
GRIS="\033[0m"
MARRON="\33[38;5;138m"

sed -i "6c Exec=sh cerrar_svxlink_05.sh" /home/pi/Desktop/Abrir_SVXLink.desktop
sed -i "7c Icon=/home/pi/pi/SVXLINK_ON.png" /home/pi/Desktop/Abrir_SVXLink.desktop
sed -i "4c Name[es_ES]=Cerrar SVXLINK" /home/pi/Desktop/Abrir_SVXLink.desktop

sed -i "8c SVXLINK=ON" /home/pi/status.ini

# sudo svxlink
xterm -geometry 87x24+1287+479 -bg black -fg yellow -fa ‘verdana’ -fs 9x -T SVXLINK -e sudo svxlink

sed -i "6c Exec=sh ejecutar_svxlink_05.sh" /home/pi/Desktop/Abrir_SVXLink.desktop
sed -i "7c Icon=/home/pi/pi/DMRPLUS_EDITOR.png" /home/pi/Desktop/Abrir_SVXLink.desktop
sed -i "4c Name[es_ES]=Abrir SVXLINK" /home/pi/Desktop/Abrir_SVXLink.desktop
