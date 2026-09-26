#!/bin/bash

sudo systemctl restart dmr2ysf.service
sudo systemctl restart analog_bridge.service
sudo systemctl restart ircddbgatewayd.service
sudo systemctl restart ircddbgateway.service
sudo systemctl restart md380-emu.service
sudo systemctl restart mmdvm_bridge.service
sudo systemctl restart nxdngateway.service
sudo systemctl restart p25gateway.service

sed -i "18c DVSWITCH=ON" /home/pi/status.ini
