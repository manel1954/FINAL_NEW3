#!/bin/bash

#Colores
ROJO="\033[1;31m"
VERDE="\033[1;32m"
BLANCO="\033[1;37m"
AMARILLO="\033[1;33m"
CIAN="\033[1;36m"
GRIS="\033[0m"
MARRON="\33[38;5;138m"                       
                        
                        
                        cd /home/pi/A108/qt
                        ./qt_popus_actualizando_reflectores
                        clear
                        echo "\v\v"
                        echo "${VERDE}"
                        echo "            ********************************************************"
                        echo "${BLANCO}"
                        echo "                    ACTUALIZANDO REFELECTORES Y SALAS DSTAR"
                        echo "${VERDE}"
                        echo "            ********************************************************"
                
                        #cambiado el 26-08-2020-2020
                        cd /usr/share/opendv
                        sudo curl --fail -o DExtra_Hosts.txt -s http://www.pistar.uk/downloads/DExtra_Hosts.txt
                        sudo curl --fail -o DCS_Hosts.txt -s http://www.pistar.uk/downloads/DCS_Hosts.txt
                        sudo curl --fail -o DPlus_Hosts.txt -s http://www.pistar.uk/downloads/DPlus_Hosts.txt
                        sudo curl --fail -o XLXHosts.txt -s http://www.pistar.uk/downloads/XLXHosts.txt
                        
                        sudo chmod 777 -R /usr/local/share/opendv
                        cp DExtra_Hosts.txt /usr/local/share/opendv
                        cp DPlus_Hosts.txt /usr/local/share/opendv
                        cp DCS_Hosts.txt /usr/local/share/opendv
                        cp XLXHosts.txt /home/pi/DMRGateway
                        
                        #Dv4mini
                        cd /usr/local/share/opendv/
                        sudo cp DExtra_Hosts.txt /home/pi/dv4mini/xref.ip
                        sleep 2     
                       
                        clear  
                        echo "\v\v"  
                        echo "${VERDE}"
                        echo "            ********************************************************"
                        echo "${AMARILLO}"
                        echo "             SE HAN ACTUALIZADO TODOS LOS REFLECTORES Y SALAS DSTAR"
                        echo "${VERDE}"
                        echo "            ********************************************************"
                        sleep 4                        
                        exit

