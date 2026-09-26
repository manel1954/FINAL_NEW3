#!/bin/bash

frecuencia=$(awk "NR==13" /home/pi/MMDVMHost/MMDVMNXDN.ini)
frecuencia=`expr substr $frecuencia 13 9`
sed -i "90c $frecuencia" /home/pi/status.ini

puerto=$(awk "NR==51" /home/pi/MMDVMHost/MMDVMNXDN.ini)
puerto=`expr substr $puerto 15 14`
sed -i "91c $puerto" /home/pi/status.ini

#cd /home/pi/DMR2NXDN
#xterm -geometry 88x6+1283+665 -bg violet -fg black -fa ‘verdana’ -fs 9x -T DMR2NXDN -e sudo ./DMR2NXDN DMR2NXDN.ini & 
#cd /home/pi/MMDVMHost
#xterm -geometry 88x9+1283+787 -bg violet -fg black -fa ‘verdana’ -fs 9x -T MMDVMDMR2NXDN -e sudo ./DMR2NXDN MMDVMDMR2NXDN.ini & 
#cd /home/pi/NXDNClients/NXDNGateway
#xterm -geometry 88x3+1283+960 -bg violet -fg black -fa ‘verdana’ -fs 9x -T NXDNGateway -e sudo ./NXDNGateway NXDNGateway.ini

cd /home/pi/MMDVMHost
#/home/pi/SYSTEM/./qt_info_nxdn & sudo lxterminal --geometry=80x12 -e ./MMDVMNXDN MMDVMNXDN.ini &
xterm -geometry 88x9+1274+787 -bg blue -fg white -fa ‘verdana’ -fs 9x -T CONSOLA_MMDVMNXDN -e sudo ./MMDVMNXDN MMDVMNXDN.ini &


cd /home/pi/NXDNClients/NXDNGateway
xterm -geometry 88x6+1274+960 -bg blue -fg white -fa ‘verdana’ -fs 9x -T CONSOLA_NXDNGateway -e sudo ./NXDNGateway NXDNGateway.ini




