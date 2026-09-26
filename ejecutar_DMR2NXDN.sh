#!/bin/bash

frecuencia=$(awk "NR==13" /home/pi/MMDVMHost/MMDVMDMR2NXDN.ini)
frecuencia=`expr substr $frecuencia 13 9`
sed -i "92c $frecuencia" /home/pi/status.ini

puerto=$(awk "NR==51" /home/pi/MMDVMHost/MMDVMDMR2NXDN.ini)
puerto=`expr substr $puerto 15 14`
sed -i "93c $puerto" /home/pi/status.ini

cd /home/pi/DMR2NXDN
xterm -geometry 88x6+1283+665 -bg violet -fg black -fa ‘verdana’ -fs 9x -T DMR2NXDN -e sudo ./DMR2NXDN DMR2NXDN.ini & 
cd /home/pi/MMDVMHost
xterm -geometry 88x9+1283+787 -bg violet -fg black -fa ‘verdana’ -fs 9x -T MMDVMDMR2NXDN -e sudo ./DMR2NXDN MMDVMDMR2NXDN.ini & 
cd /home/pi/NXDNClients/NXDNGateway
xterm -geometry 88x3+1283+960 -bg violet -fg black -fa ‘verdana’ -fs 9x -T NXDNGateway -e sudo ./NXDNGateway NXDNGateway.ini


