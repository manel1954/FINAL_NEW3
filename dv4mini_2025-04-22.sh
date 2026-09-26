#!/bin/bash
                        #sudo rm -r /home/pi/A108/DV4MINI/
                        #cd /home/pi/A108
                        #git clone http://github.com/ea3eiz/DV4MINI
                        #sudo rm -r /home/pi/dv4mini
                        #sudo rm /usr/bin/dv_serial
                        #sudo mkdir /home/pi/dv4mini
                        #sudo chmod 777 -R /home/pi/dv4mini
                        cd /home/pi/A108/DV4MINI-RPI_2025_04_22/
                        sudo cp dv_serial /home/pi/dv4mini
                        sudo cp dv4mini.exe /home/pi/dv4mini
                        sudo cp xref.ip /home/pi/dv4mini
                        sudo cp dv_serial /usr/bin/
                        cd /usr/bin/
                        sudo chmod 777 dv_serial
                        cd /home/pi/dv4mini
                        sudo chmod 777 dv_serial
