#!/bin/bash
sudo killall -9 MMDVMDMRGATEWAY
sudo killall -9 DMRGateway
sed -i "19c DMRGateway=OFF" /home/pi/status.ini
