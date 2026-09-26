#!/bin/bash
sudo killall ircddbgateway

sed -i "1c D-STAR=OFF" /home/pi/status.ini
