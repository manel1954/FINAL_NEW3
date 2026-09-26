#!/bin/bash

frecuencia=$(awk "NR==13" /home/pi/MMDVMHost/MMDVMFUSION.ini)
frecuencia=`expr substr $frecuencia 13 9`
sed -i "78c $frecuencia" /home/pi/status.ini

puerto=$(awk "NR==51" /home/pi/MMDVMHost/MMDVMFUSION.ini)
puerto=`expr substr $puerto 15 14`
sed -i "79c $puerto" /home/pi/status.ini

cd /home/pi/YSFClients/YSFGateway
xterm -geometry 87x6+1287+943 -bg black -fg orange -fa 'serift' -fs 9x -T YSFGateway -e sudo ./YSFGateway YSFGateway.ini & 
cd /home/pi/MMDVMHost
xterm -geometry 87x5+1287+832 -bg black -fg orange -fa 'serift' -fs 9x -T MMDVMFUSION -e sudo ./MMDVMFUSION MMDVMFUSION.ini


