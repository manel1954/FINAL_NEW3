#!/bin/bash
sudo killall MMDVMESPECIAL

sed -i "10c MMDVMESPECIAL=OFF" /home/pi/status.ini


