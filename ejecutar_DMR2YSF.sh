#!/bin/bash

frecuencia=$(awk "NR==13" /home/pi/MMDVMHost/MMDVMDMR2YSF.ini)
frecuencia=`expr substr $frecuencia 13 9`
sed -i "82c $frecuencia" /home/pi/status.ini

puerto=$(awk "NR==51" /home/pi/MMDVMHost/MMDVMDMR2YSF.ini)
puerto=`expr substr $puerto 15 14`
sed -i "83c $puerto" /home/pi/status.ini

cd /home/pi/DMR2YSF
xterm -geometry 87x6+1287+709 -bg black -fg yellow -fa 'serift' -fs 9x -T DMR2YSF -e sudo ./DMR2YSF DMR2YSF.ini &

cd /home/pi/MMDVMHost
xterm -geometry 87x5+1287+832 -bg black -fg yellow -fa 'serift' -fs 9x -T MMDVMDMR2YSF -e sudo ./DMR2YSF MMDVMDMR2YSF.ini &

cd /home/pi/YSFClients/YSFGateway
xterm -geometry 87x5+1287+943 -bg black -fg yellow -fa 'serift' -fs 9x -T YSFGateway -e sudo ./YSFGateway YSFGateway.ini &




 
  