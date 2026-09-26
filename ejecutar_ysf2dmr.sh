#!/bin/bash

sed -i "14c YSF2DMR=ON" /home/pi/status.ini

frecuencia=$(awk "NR==13" /home/pi/MMDVMHost/MMDVMFUSION.ini)
frecuencia=`expr substr $frecuencia 13 9`
sed -i "88c $frecuencia" /home/pi/status.ini

puerto=$(awk "NR==51" /home/pi/MMDVMHost/MMDVMFUSION.ini)
puerto=`expr substr $puerto 15 14`
sed -i "89c $puerto" /home/pi/status.ini

cd /home/pi/YSF2DMR

xterm -geometry 87x8+1287+905 -bg black -fg orange -fa 'serift' -fs 9x -T YSF2DMR -e sudo ./YSF2DMR YSF2DMR.ini &

sleep 2

cd /home/pi/MMDVMHost
xterm -geometry 87x15+1287+643 -bg black -fg orange -fa 'serift' -fs 9x -T MMDVMFUSION -e sudo ./MMDVMFUSION MMDVMFUSION.ini 




