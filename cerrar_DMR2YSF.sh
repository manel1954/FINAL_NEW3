#!/bin/bash

sudo killall -9 DMR2YSF
sudo killall -9 YSFGateway
sudo killall -9 MMDVMDMR2YSF

sed -i "15c DMR2YSF=OFF" /home/pi/status.ini