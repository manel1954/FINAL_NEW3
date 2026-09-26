#!/bin/bash
 
                        cd /home/pi/Downloads 

                        wget https://download.nomachine.com/download/8.14/Arm/nomachine_8.14.2_1_armhf.deb 
                        
                        sudo dpkg -i nomachine_8.14.2_1_armhf.deb

                        sudo apt -f install -y
                        
                        sudo rm nomachine_8.14.2_1_armhf.deb*

                        