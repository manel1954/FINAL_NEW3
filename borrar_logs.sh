#!/bin/bash

cd /home/pi/A108/qt
./qt_popus_borrando_logs

sudo rm /home/pi/MMDVMHost/*.log
sleep 1
sudo rm /var/log/irc*.log
sleep 1
sudo rm /home/pi/YSFClients/YSFGateway/*.log
sleep 1
sudo rm /home/pi/YSF2DMR/*.log
sleep 1
sudo rm /home/pi/DMR2NXDN/*.log
sleep 1
sudo rm /home/pi/DMR2YSF/*.log
sleep 1
sudo rm /home/pi/NXDNClients/NXDNGateway/*.log
sleep 1
sudo rm /var/log/*.log 



