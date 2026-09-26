#!/bin/bash
sudo killall MMDVMPLUS

sed -i "6c MMDVMPLUS=OFF" /home/pi/status.ini

