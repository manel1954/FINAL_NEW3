#!/bin/bash

#frecuencia=$(awk "NR==13" /home/pi/MMDVMHost/MMDVMFUSION.ini)
#frecuencia=`expr substr $frecuencia 13 9`
#sed -i "78c $frecuencia" /home/pi/status.ini
#
#puerto=$(awk "NR==51" /home/pi/MMDVMHost/MMDVMFUSION.ini)
#puerto=`expr substr $puerto 15 14`
#sed -i "79c $puerto" /home/pi/status.ini

cd /home/pi/YSFClients2/YSFGateway
xterm -geometry 87x6+1287+211 -bg black -fg orange -fa 'serift' -fs 9x -T YSFGateway2 -e sudo ./YSFGateway YSFGateway.ini & 
cd /home/pi/MMDVMHost
xterm -geometry 87x5+1287+100 -bg black -fg orange -fa 'serift' -fs 9x -T MMDVMFUSION2 -e sudo ./MMDVMFUSION2 MMDVMFUSION2.ini &


