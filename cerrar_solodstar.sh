#!/bin/bash
sudo killall MMDVMDSTAR
sudo killall ircddbgateway

sed -i "13c SOLODSTAR=OFF" /home/pi/status.ini
