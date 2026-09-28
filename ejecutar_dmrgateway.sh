#!/bin/bash
# hoy 24-11-2024
sed -i "19c DMRGateway=ON" /home/pi/status.ini

frecuencia=$(awk "NR==13" /home/pi/MMDVMHost/MMDVMDMRGateway.ini)
frecuencia=`expr substr $frecuencia 13 9`
sed -i "86c $frecuencia" /home/pi/status.ini

puerto=$(awk "NR==51" /home/pi/MMDVMHost/MMDVMDMRGateway.ini)
puerto=`expr substr $puerto 15 14`
sed -i "87c $puerto" /home/pi/status.ini

cd /home/pi/DMRGateway

xterm -geometry 80x13+1340+543 -bg black -fg white -fa 'serift' -fs 9x -T DMRGateway -e sudo ./DMRGateway DMRGateway.ini &

sleep 2

cd /home/pi/MMDVMHost
xterm -geometry 80x13+1340+782 -bg black -fg white -fa 'serift' -fs 9x -T MMDVMDMRGATEWAY -e sudo ./MMDVMDMRGATEWAY MMDVMDMRGateway.ini 





