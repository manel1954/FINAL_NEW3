#!/bin/bash
                        cd /home/pi/A108
                        git clone http://github.com/ea3eiz/DV4MINI
                        sudo rm -r /home/pi/dv4mini
                        sudo rm /usr/bin/dv_serial
                        sudo mkdir /home/pi/dv4mini
                        sudo chmod 777 -R /home/pi/dv4mini
                        cd /home/pi/A108/DV4MINI/20170517
                        cp dv_serial /home/pi/dv4mini
                        cp dv4mini.exe /home/pi/dv4mini
                        cp xref.ip /home/pi/dv4mini
                        sudo cp dv_serial /usr/bin/
                        cd /usr/bin/
                        sudo chmod 777 dv_serial
                        cd /home/pi/dv4mini
                        sudo chmod 777 dv_serial
                        

                        