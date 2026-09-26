#!/bin/bash
            cd /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f TODOS_LOS_INIS.ini /home/pi/MMDVMHost

            cp -f bluetooth.sh /home/pi/.local
            # Cambio 8-04-2024
            cp -f station.cfg /home/pi/radiosonde_auto_rx/auto_rx
            #            cp -f MMDVM.ini /home/pi/MMDVMHost
            cp -f MMDVM.ini_copia /home/pi/MMDVMHost
            cp -f MMDVM.ini_copia2 /home/pi/MMDVMHost
            cp -f MMDVM.ini_copia3 /home/pi/MMDVMHost
            cp -f MMDVM.ini_original /home/pi/MMDVMHost

            cp -f MMDVMBM.ini /home/pi/MMDVMHost
            cp -f MMDVMBM.ini_copia /home/pi/MMDVMHost
            cp -f MMDVMBM.ini_copia2 /home/pi/MMDVMHost
            cp -f MMDVMBM.ini_copia3 /home/pi/MMDVMHost 

            cp -f MMDVMPLUS.ini /home/pi/MMDVMHost
            cp -f MMDVMPLUS.ini_copia /home/pi/MMDVMHost
            cp -f MMDVMPLUS.ini_copia2 /home/pi/MMDVMHost
            cp -f MMDVMPLUS.ini_copia3 /home/pi/MMDVMHost

            cp -f MMDVMESPECIAL.ini /home/pi/MMDVMHost
            cp -f MMDVMESPECIAL.ini_copia /home/pi/MMDVMHost
            cp -f MMDVMESPECIAL.ini_copia2 /home/pi/MMDVMHost
            cp -f MMDVMESPECIAL.ini_copia3 /home/pi/MMDVMHost

            #solo Dstar y solo Fusion
            cp -f MMDVMDSTAR.ini /home/pi/MMDVMHost
            cp -f MMDVMFUSION.ini /home/pi/MMDVMHost
            #fin  Dstar y solo Fusion

            cp -f YSF2DMR.ini /home/pi/YSF2DMR
            cp -f YSF2DMR.ini_copia_01 /home/pi/YSF2DMR
            cp -f YSF2DMR.ini_copia_02 /home/pi/YSF2DMR
            cp -f YSF2DMR.ini_copia_03 /home/pi/YSF2DMR
            cp -f YSF2DMR.ini_copia_04 /home/pi/YSF2DMR
            
            cp -f TG-YSFList.txt /home/pi/DMR2YSF
          
            cp -f tg_ysf.txt /home/pi/.local
            cp -f nombre_salas_ysf.txt /home/pi/.local
            cp -f autoarranque.ini /home/pi/.local
            cp -f memoria_ysf2dmr /home/pi/.local
            cp -f memoria_dmrplus /home/pi/.local #22-02-2021
            cp -f memoria_bm /home/pi/.local #22-02-2021
            cp -f memoria_radio /home/pi/.local #22-02-2021
            cp -f memoria_especial /home/pi/.local #22-02-2021
            cp -f memoria_solodstar /home/pi/.local #22-02-2021
            cp -f memoria_solofusion /home/pi/.local #22-02-2021



                            info=$(awk "NR==1" /home/pi/.local/autoarranque.ini)
                            if [ $info = "ircDDB=OFF" ]
                            then
                            sudo rm /home/pi/.config/autostart/IRCDDB.desktop
                            else
                       		cd /home/pi/AUTOARRANQUEA108
                  		    sudo cp IRCDDB.desktop /home/pi/.config/autostart
                            fi

                            info=$(awk "NR==2" /home/pi/.local/autoarranque.ini)
                            if [ $info = "BlueDV=OFF" ]
                            then
                            sudo rm /home/pi/.config/autostart/BLUEDV.desktop
                            else
                            cd /home/pi/AUTOARRANQUEA108
                            sudo cp BLUEDV.desktop /home/pi/.config/autostart
                            fi

                            info=$(awk "NR==3" /home/pi/.local/autoarranque.ini)
                            if [ $info = "YSF=OFF" ]
                            then
                            sudo rm /home/pi/.config/autostart/YSF.desktop
                            else
                            cd /home/pi/AUTOARRANQUEA108
                            sudo cp YSF.desktop /home/pi/.config/autostart
                            fi

                            info=$(awk "NR==4" /home/pi/.local/autoarranque.ini)
                            if [ $info = "DV4mini=OFF" ]
                            then
                            sudo rm /home/pi/.config/autostart/DV4MINI.desktop
                            else
                            cd /home/pi/AUTOARRANQUEA108
                            sudo cp DV4MINI.desktop /home/pi/.config/autostart
                            fi

                            info=$(awk "NR==5" /home/pi/.local/autoarranque.ini)
                            if [ $info = "Radio=OFF" ]
                            then
                            sudo rm /home/pi/.config/autostart/RADIO.desktop
                            else
                            cd /home/pi/AUTOARRANQUEA108
                            sudo cp RADIO.desktop /home/pi/.config/autostart
                            fi

                            info=$(awk "NR==6" /home/pi/.local/autoarranque.ini)
                            if [ $info = "DMR+=OFF" ]
                            then
                            sudo rm /home/pi/.config/autostart/DMRPLUS.desktop
                            else
                            cd /home/pi/AUTOARRANQUEA108
                            sudo cp DMRPLUS.desktop /home/pi/.config/autostart
                            fi

                            info=$(awk "NR==7" /home/pi/.local/autoarranque.ini)
                            if [ $info = "ESPECIAL=OFF" ]
                            then
                            sudo rm /home/pi/.config/autostart/LIBRE.desktop
                            else
                            cd /home/pi/AUTOARRANQUEA108
                            sudo cp LIBRE.desktop /home/pi/.config/autostart
                            fi

                            info=$(awk "NR==8" /home/pi/.local/autoarranque.ini)
                            if [ $info = "BM=OFF" ]
                            then
                            sudo rm /home/pi/.config/autostart/BM.desktop
                            else
                            cd /home/pi/AUTOARRANQUEA108
                            sudo cp BM.desktop /home/pi/.config/autostart
                            fi

                            info=$(awk "NR==9" /home/pi/.local/autoarranque.ini)
                            if [ $info = "SVXLINK=OFF" ]
                            then
                            sudo rm /home/pi/.config/autostart/SVXLINK.desktop
                            else
                            cd /home/pi/AUTOARRANQUEA108
                            sudo cp SVXLINK.desktop /home/pi/.config/autostart
                            fi

                            info=$(awk "NR==10" /home/pi/.local/autoarranque.ini)
                            if [ $info = "SOLO_DSTAR=OFF" ]
                            then
                            sudo rm /home/pi/.config/autostart/DSTARSOLO_05.desktop
                            else
                            cd /home/pi/AUTOARRANQUEA108
                            sudo cp DSTARSOLO_05.desktop /home/pi/.config/autostart
                            fi

                            info=$(awk "NR==11" /home/pi/.local/autoarranque.ini)
                            if [ $info = "SOLO_FUSION=OFF" ]
                            then
                            sudo rm /home/pi/.config/autostart/FUSIONSOLO.desktop
                            else
                            cd /home/pi/AUTOARRANQUEA108
                            sudo cp FUSIONSOLO.desktop /home/pi/.config/autostart
                            fi

                            info=$(awk "NR==12" /home/pi/.local/autoarranque.ini)
                            if [ $info = "DVRPTR=OFF" ]
                            then
                            sudo rm /home/pi/.config/autostart/DVRPTR.desktop
                            else
                            cd /home/pi/AUTOARRANQUEA108
                            sudo cp DVRPTR.desktop /home/pi/.config/autostart
                            fi

                            info=$(awk "NR==13" /home/pi/.local/autoarranque.ini)
                            if [ $info = "AMBE_SERVER=OFF" ]
                            then
                            sudo rm /home/pi/.config/autostart/AMBE_SERVER.desktop
                            else
                            cd /home/pi/AUTOARRANQUEA108
                            sudo cp AMBE_SERVER.desktop /home/pi/.config/autostart
                            fi

                            info=$(awk "NR==14" /home/pi/.local/autoarranque.ini)
                            if [ $info = "YSF2DMR=OFF" ]
                            then
                            sudo rm /home/pi/.config/autostart/YSF2DMR.desktop
                            else
                            cd /home/pi/AUTOARRANQUEA108
                            sudo cp YSF2DMR.desktop /home/pi/.config/autostart
                            fi

                            info=$(awk "NR==15" /home/pi/.local/autoarranque.ini)
                            if [ $info = "DMR2YSF=OFF" ]
                            then
                            sudo rm /home/pi/.config/autostart/DMR2YSF.desktop
                            else
                            cd /home/pi/AUTOARRANQUEA108
                            sudo cp DMR2YSF.desktop /home/pi/.config/autostart
                            fi

                            info=$(awk "NR==16" /home/pi/.local/autoarranque.ini)
                            if [ $info = "DMR2NXDN=OFF" ]
                            then
                            sudo rm /home/pi/.config/autostart/DMR2NXDN.desktop
                            else
                            cd /home/pi/AUTOARRANQUEA108
                            sudo cp DMR2NXDN.desktop /home/pi/.config/autostart
                            fi

                            info=$(awk "NR==17" /home/pi/.local/autoarranque.ini)
                            if [ $info = "NXDN=OFF" ]
                            then
                            sudo rm /home/pi/.config/autostart/NXDN.desktop
                            else
                            cd /home/pi/AUTOARRANQUEA108
                            sudo cp NXDN.desktop /home/pi/.config/autostart
                            fi

                            info=$(awk "NR==18" /home/pi/.local/autoarranque.ini)
                            if [ $info = "DMRGateway=OFF" ]
                            then
                            sudo rm /home/pi/.config/autostart/DMRGateway.desktop
                            else
                            cd /home/pi/AUTOARRANQUEA108
                            sudo cp DMRGateway.desktop /home/pi/.config/autostart
                            fi

                            info=$(awk "NR==19" /home/pi/.local/autoarranque.ini)
                            if [ $info = "DMR2M17=OFF" ]
                            then
                            sudo rm /home/pi/.config/autostart/ABRIR_DMR2M17.desktop
                            else
                            cd /home/pi/AUTOARRANQUEA108
                            cp /home/pi/Desktop/ABRIR_DMR2M17.desktop /home/pi/.config/autostart
                            fi      
                                
            cd /home/pi/.local/COPIA_SEGURIDAD/Downloads           

            cp -f MMDVMDMR2NXDN.ini /home/pi/MMDVMHost
            cp -f MMDVMNXDN.ini /home/pi/MMDVMHost
            cp -f MMDVMDMR2YSF.ini /home/pi/MMDVMHost

            cp -f DMR2NXDN.ini  /home/pi/DMR2NXDN
            cp -f NXDNGateway.ini /home/pi/NXDNClients/NXDNGateway
            cp -f DMR2YSF.ini /home/pi/DMR2YSF

            cp -f YSFGateway.ini /home/pi/YSFClients/YSFGateway/
            cp -f YSFGateway.ini_1 /home/pi/YSFClients/YSFGateway/

            cp -f BlueDVconfig.ini /home/pi/bluedv/

            cp -f svxlink.conf /usr/local/etc/svxlink/

            cp -f ambe_server.ini  /home/pi/.local/
            
            cp -f ModuleEchoLink.conf /usr/local/etc/svxlink/svxlink.d/

            cp ircddbgateway /usr/local/etc/opendv/
            cp dstarrepeater /usr/local/etc/opendv/

            cp info_panel_control.ini /home/pi/

            cp -f MMDVMDMRGateway.ini /home/pi/MMDVMHost/
            cp -f DMRGateway.ini /home/pi/DMRGateway/

            cp -f MMDVMDMR2M17.ini /home/pi/MMDVMHost/
            cp -f DMR2M17.ini /home/pi/DMR2M17/

cp -f info.ini /home/pi/

cp -f regla2 /home/pi/.local/
cp -f regla3 /home/pi/.local/
cp -f regla4 /home/pi/.local/
cp -f regla5 /home/pi/.local/
cp -f regla6 /home/pi/.local/
cp -f regla7 /home/pi/.local/
cp -f regla8 /home/pi/.local/
cp -f regla9 /home/pi/.local/
cp -f reglaxlx /home/pi/.local/

# Restaura todos los datos de Dvswitch
indicativo=$(awk "NR==1" /home/pi/.local/COPIA_SEGURIDAD/Downloads/datos_dvswitch)          
sudo sed -i "2c Callsign=$indicativo" /opt/MMDVM_Bridge/MMDVM_Bridge.ini
sudo sed -i "2c Callsign=$indicativo" /opt/MMDVM_Bridge/brandmeister_esp.ini
sudo sed -i "2c Callsign=$indicativo" /opt/MMDVM_Bridge/dmrplus.ini
sudo sed -i "2c Callsign=$indicativo" /opt/MMDVM_Bridge/especial.ini
sudo sed -i "2c Callsign=$indicativo" /opt/NXDNGateway.ini
sudo sed -i "2c gatewayCallsign=$indicativo" /etc/ircddbgateway
sudo sed -i "95c ircddbUsername=$indicativo" /etc/ircddbgateway
sudo sed -i "117c dplusLogin=$indicativo" /etc/ircddbgateway
sudo sed -i "2c Callsign=$indicativo" /opt/MMDVM_Bridge/MMDVM_Bridge_FCS.ini

id=$(awk "NR==3" /home/pi/.local/COPIA_SEGURIDAD/Downloads/datos_dvswitch)
id_nxdn=`expr substr $id 3 5`
sudo sed -i "30c ID = $id" /opt/MMDVM_Bridge/DVSwitch.ini
sudo sed -i "40c FallbackID = $id" /opt/MMDVM_Bridge/DVSwitch.ini
sudo sed -i "38c gatewayDmrId = $id" /opt/Analog_Bridge/Analog_Bridge.ini
sudo sed -i "38c gatewayDmrId = $id" /opt/Analog_Bridge/dmr.ini
sudo sed -i "38c gatewayDmrId = $id" /opt/Analog_Bridge/dstar.ini
sudo sed -i "38c gatewayDmrId = $id" /opt/Analog_Bridge/especial.ini
sudo sed -i "38c gatewayDmrId = $id" /opt/Analog_Bridge/nxdn.ini
sudo sed -i "43c ;; FallbackID = $id_nxdn" /opt/Analog_Bridge/nxdn.ini
sudo sed -i "44c ;; NXDNFallbackID = $id_nxdn" /opt/Analog_Bridge/nxdn.ini
sudo sed -i "38c gatewayDmrId = $id" /opt/Analog_Bridge/ysf.ini
sudo sed -i "43c ;; FallbackID = $id" /opt/Analog_Bridge/ysf.ini
sudo sed -i "38c gatewayDmrId = $id" /opt/Analog_Bridge/FCS.ini

id2=$(awk "NR==4" /home/pi/.local/COPIA_SEGURIDAD/Downloads/datos_dvswitch)
sudo sed -i "3c Id=$id2" /opt/MMDVM_Bridge/MMDVM_Bridge.ini
sudo sed -i "3c Id=$id2" /opt/MMDVM_Bridge/brandmeister_esp.ini
sudo sed -i "3c Id=$id2" /opt/MMDVM_Bridge/dmrplus.ini
sudo sed -i "3c Id=$id2" /opt/MMDVM_Bridge/especial.ini
sudo sed -i "39c repeaterID = $id2" /opt/Analog_Bridge/Analog_Bridge.ini
sudo sed -i "39c repeaterID = $id2" /opt/Analog_Bridge/dmr.ini
sudo sed -i "39c repeaterID = $id2" /opt/Analog_Bridge/dstar.ini
sudo sed -i "39c repeaterID = $id2" /opt/Analog_Bridge/especial.ini
sudo sed -i "39c repeaterID = $id2" /opt/Analog_Bridge/nxdn.ini
sudo sed -i "39c repeaterID = $id2" /opt/Analog_Bridge/ysf.ini
sudo sed -i "39c repeaterID = $id2" /opt/Analog_Bridge/FCS.ini
sudo sed -i "3c Id=$id2" /opt/MMDVM_Bridge/MMDVM_Bridge_FCS.ini

Latitude=$(awk "NR==5" /home/pi/.local/COPIA_SEGURIDAD/Downloads/datos_dvswitch)
sudo sed -i "11c Latitude=$Latitude" /opt/MMDVM_Bridge/MMDVM_Bridge.ini
sudo sed -i "11c Latitude=$Latitude" /opt/MMDVM_Bridge/brandmeister_esp.ini
sudo sed -i "11c Latitude=$Latitude" /opt/MMDVM_Bridge/dmrplus.ini
sudo sed -i "11c Latitude=$Latitude" /opt/MMDVM_Bridge/especial.ini
sudo sed -i "11c Latitude=$Latitude" /opt/MMDVM_Bridge/MMDVM_Bridge_FCS.ini

Longitude=$(awk "NR==6" /home/pi/.local/COPIA_SEGURIDAD/Downloads/datos_dvswitch)
sudo sed -i "12c Longitude=$Longitude" /opt/MMDVM_Bridge/MMDVM_Bridge.ini
sudo sed -i "12c Longitude=$Longitude" /opt/MMDVM_Bridge/brandmeister_esp.ini
sudo sed -i "12c Longitude=$Longitude" /opt/MMDVM_Bridge/dmrplus.ini
sudo sed -i "12c Longitude=$Longitude" /opt/MMDVM_Bridge/especial.ini
sudo sed -i "12c Longitude=$Longitude" /opt/MMDVM_Bridge/MMDVM_Bridge_FCS.ini

port=$(awk "NR==7" /home/pi/.local/COPIA_SEGURIDAD/Downloads/datos_dvswitch)
sudo sed -i "55c txPort = $port" /opt/Analog_Bridge/Analog_Bridge.ini
sudo sed -i "55c txPort = $port" /opt/Analog_Bridge/dmr.ini
sudo sed -i "55c txPort = $port" /opt/Analog_Bridge/dstar.ini
sudo sed -i "55c txPort = $port" /opt/Analog_Bridge/especial.ini
sudo sed -i "55c txPort = $port" /opt/Analog_Bridge/nxdn.ini
sudo sed -i "55c txPort = $port" /opt/Analog_Bridge/ysf.ini
sudo sed -i "56c rxPort = $port" /opt/Analog_Bridge/Analog_Bridge.ini
sudo sed -i "56c rxPort = $port" /opt/Analog_Bridge/dmr.ini
sudo sed -i "56c rxPort = $port" /opt/Analog_Bridge/dstar.ini
sudo sed -i "56c rxPort = $port" /opt/Analog_Bridge/especial.ini
sudo sed -i "56c rxPort = $port" /opt/Analog_Bridge/nxdn.ini
sudo sed -i "56c rxPort = $port" /opt/Analog_Bridge/ysf.ini


location=$(awk "NR==8" /home/pi/.local/COPIA_SEGURIDAD/Downloads/datos_dvswitch)
sudo sed -i "14c $location" /opt/MMDVM_Bridge/MMDVM_Bridge.ini
sudo sed -i "14c $location" /opt/MMDVM_Bridge/brandmeister_esp.ini
sudo sed -i "14c $location" /opt/MMDVM_Bridge/dmrplus.ini
sudo sed -i "14c $location" /opt/MMDVM_Bridge/especial.ini
#sudo sed -i "17c $location" /opt/NXDNGateway.ini
sudo sed -i "14c $location" /opt/MMDVM_Bridge/MMDVM_Bridge_FCS.ini

url=$(awk "NR==9" /home/pi/.local/COPIA_SEGURIDAD/Downloads/datos_dvswitch)
sudo sed -i "16c URL=$url" /opt/MMDVM_Bridge/MMDVM_Bridge.ini
sudo sed -i "16c URL=$url" /opt/MMDVM_Bridge/brandmeister_esp.ini
sudo sed -i "16c URL=$url" /opt/MMDVM_Bridge/dmrplus.ini
sudo sed -i "16c URL=$url" /opt/MMDVM_Bridge/especial.ini
sudo sed -i "16c URL=$url" /opt/MMDVM_Bridge/MMDVM_Bridge_FCS.ini

address_especial=$(awk "NR==2" /home/pi/.local/COPIA_SEGURIDAD/Downloads/datos_dvswitch)
sudo sed -i "70c $address_especial" /opt/MMDVM_Bridge/especial.ini

password_especial=$(awk "NR==10" /home/pi/.local/COPIA_SEGURIDAD/Downloads/datos_dvswitch)
sudo sed -i "74c $password_especial" /opt/MMDVM_Bridge/especial.ini

port_especial=$(awk "NR==11" /home/pi/.local/COPIA_SEGURIDAD/Downloads/datos_dvswitch)
sudo sed -i "71c $port_especial" /opt/MMDVM_Bridge/especial.ini

sala_fcs=$(awk "NR==12" /home/pi/.local/COPIA_SEGURIDAD/Downloads/datos_dvswitch)
sudo sed -i "40c txTg = $sala_fcs" /opt/Analog_Bridge/FCS.ini
#Modificación 04-05-2020
#sudo sed -i "42c Startup=$sala_fcs" /home/pi/YSFClients/YSFGateway/YSFGateway.ini


sala_nxdn=$(awk "NR==13" /home/pi/.local/COPIA_SEGURIDAD/Downloads/datos_dvswitch)
sudo sed -i "10c $sala_nxdn" /opt/NXDNClients/NXDNGateway/private/NXDNHosts.txt

selfcare=$(awk "NR==14" /home/pi/.local/COPIA_SEGURIDAD/Downloads/datos_dvswitch)
sudo sed -i "74c $selfcare" /opt/MMDVM_Bridge/brandmeister_esp.ini

reflector_dstar=$(awk "NR==15" /home/pi/.local/COPIA_SEGURIDAD/Downloads/datos_dvswitch)
sudo sed -i "18c $reflector_dstar" /etc/ircddbgateway

sudo cp -f hblink.cfg /opt/HBlink3/
sudo cp -f rules.py /opt/HBlink3/
sudo cp -f config.py /opt/HBmonitor/

sudo cp -f monitor.py /opt/HBmonitor/
sudo cp -f index_template.html /opt/HBmonitor/

sudo cp -f info.ini /home/pi/
