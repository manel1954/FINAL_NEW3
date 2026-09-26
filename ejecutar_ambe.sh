#!/bin/bash

sed -i "26c AMBE=ON" /home/pi/status.ini

puerto_router=$(awk "NR==1" /home/pi/.local/ambe_server.ini) 
puerto_modem=$(awk "NR==2" /home/pi/.local/ambe_server.ini)
baut_rate=$(awk "NR==3" /home/pi/.local/ambe_server.ini)
cd /home/pi/AMBE_SERVER
sudo xterm -geometry 93x6+507+926 -bg black -fg cyan -fa 'serift' -fs 10x -T AMBE_SERVER -e sudo ./AMBEserver -p $puerto_router -i $puerto_modem -s $baut_rate &
