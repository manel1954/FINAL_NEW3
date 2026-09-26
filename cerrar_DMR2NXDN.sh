#!/bin/bash
sudo killall DMR2NXDN
sudo killall NXDNGateway
sudo killall MMDVMDMR2NXDN
sed -i "16c DMR2NXDN=OFF" /home/pi/status.ini
