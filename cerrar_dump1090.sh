#!/bin/bash

sudo killall dump1090

cd /home/pi/Desktop
sudo cp dump1090.desktop /home/pi
sed -i "6c Exec=sh -c 'cd /home/pi/SYSTEM; sudo sh ejecutar_dump1090.sh'" /home/pi/dump1090.desktop
sed -i "7c Icon=/home/pi/SYSTEM/ICO_AVION_OFF.png" /home/pi/dump1090.desktop
sed -i "10c Name[es_ES]=Abrir Dump1090" /home/pi/dump1090.desktop

cd /home/pi
sudo cp dump1090.desktop /home/pi/Desktop
#
sudo rm /home/pi/dump1090.desktop
#
