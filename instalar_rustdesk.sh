#!/bin/bash
 
                        sudo rm -R /home/pi/.config/rustdesk

                        cd /home/pi/Downloads
                        
                        wget https://github.com/rustdesk/rustdesk/releases/download/1.3.3/rustdesk-1.3.3-armv7-sciter.deb
                        
                        sudo dpkg -i rustdesk-1.3.3-armv7-sciter.deb

                        sudo apt -f install -y

                        sudo rm rustdesk-1.3.3-armv7-sciter.deb*

