#!/bin/bash
sudo killall MMDVMHost

sed -i "5c MMDVM=OFF" /home/pi/status.ini
