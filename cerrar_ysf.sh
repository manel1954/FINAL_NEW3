#!/bin/bash
sudo killall YSFGateway

sed -i "3c YSF=OFF" /home/pi/status.ini