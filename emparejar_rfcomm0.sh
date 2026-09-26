#!/bin/bash
		                clear
						echo "\33[1;32m<<<< ESCANEANDO DISPOSITIVOS BLUETOOTH >>>>"
						echo ""
						echo "\33[1;36m" # color Cian
						sudo hcitool scan
						echo "\33[1;32m" #color verde
						echo "Copia la MAC del modulo Bluetooth para pegarla en el siguiente paso"
						echo ""
						echo "\33[1;33m" #amarillo
			            echo "Pega la MAC aquí y pulsa Enter"	          		            
			            read mac
                        sudo sed -i "2c sudo rfcomm bind /dev/rfcomm0 $mac" /home/pi/.local/bluetooth.sh
                        
						clear

						sudo rfcomm bind /dev/rfcomm0 $mac				
						echo "\33[1;32m" #color verde
						echo "  ********************************************************************"
						echo "  *                   MAC ENLAZADA CORRECTAMENTE                     *"
						echo "  ********************************************************************"
						#echo ""
						#echo "\33[1;31m" #color rojo
						#echo "  ********************************************************************"
						#echo "  * DEBERÁ REINICIAR SU SISTEMA PARA ANCLARLA AL PUERTO /dev/rfcomm0 *"
						#echo "  ********************************************************************"
						#echo "\33[1;37m" #color
                        
						#read -p '  Quieres reiniciar ? S/N ' reiniciar
                        #case $reiniciar in
			  			#[sS]* ) echo ""
			  			#sudo reboot
			  			#break;;
			  			#[nN]* ) echo ""
			  			exit;
						break;
						esac