#!/bin/bash
sudo killall MMDVMFUSION
sudo killall YSFGateway

sed -i "12c SOLOFUSION=OFF" /home/pi/status.ini


