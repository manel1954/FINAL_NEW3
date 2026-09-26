#!/bin/bash
clear
            sudo rm /home/pi/.local/COPIA_SEGURIDAD/Downloads/*.*
            
            cp /home/pi/.local/datos_dvswitch /home/pi/.local/COPIA_SEGURIDAD/Downloads

            cp /home/pi/.local/bluetooth.sh /home/pi/.local/COPIA_SEGURIDAD/Downloads
            # Cambio 8-04-2024
            cp /home/pi/radiosonde_auto_rx/auto_rx/station.cfg /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cd /home/pi/MMDVMHost
            cp -f TODOS_LOS_INIS.ini /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f MMDVM.ini /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f MMDVM.ini_copia /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f MMDVM.ini_copia2 /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f MMDVM.ini_copia3 /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f MMDVM.ini_original /home/pi/.local/COPIA_SEGURIDAD/Downloads

            cp -f MMDVMBM.ini /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f MMDVMBM.ini_copia /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f MMDVMBM.ini_copia2 /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f MMDVMBM.ini_copia3 /home/pi/.local/COPIA_SEGURIDAD/Downloads

            cp -f MMDVMPLUS.ini /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f MMDVMPLUS.ini_copia /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f MMDVMPLUS.ini_copia2 /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f MMDVMPLUS.ini_copia3 /home/pi/.local/COPIA_SEGURIDAD/Downloads

            cp -f MMDVMESPECIAL.ini /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f MMDVMESPECIAL.ini_copia /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f MMDVMESPECIAL.ini_copia2 /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f MMDVMESPECIAL.ini_copia3 /home/pi/.local/COPIA_SEGURIDAD/Downloads

            cp -f MMDVMDMR2NXDN.ini /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f MMDVMDMR2YSF.ini /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f MMDVMNXDN.ini /home/pi/.local/COPIA_SEGURIDAD/Downloads

            cp -f /home/pi/DMR2NXDN/DMR2NXDN.ini  /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f /home/pi/NXDNClients/NXDNGateway/NXDNGateway.ini  /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f /home/pi/DMR2YSF/DMR2YSF.ini  /home/pi/.local/COPIA_SEGURIDAD/Downloads

            #solo Dstar y solo Fusion 
            cp -f MMDVMDSTAR.ini /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f MMDVMFUSION.ini /home/pi/.local/COPIA_SEGURIDAD/Downloads
            #fin  Dstar y solo Fusion  

            cd  /home/pi/YSF2DMR
            cp -f YSF2DMR.ini /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f YSF2DMR.ini_copia_01 /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f YSF2DMR.ini_copia_02 /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f YSF2DMR.ini_copia_03 /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f YSF2DMR.ini_copia_04 /home/pi/.local/COPIA_SEGURIDAD/Downloads

            cd  /home/pi/DMR2YSF
            cp -f TG-YSFList.txt /home/pi/.local/COPIA_SEGURIDAD/Downloads
            
            cd /home/pi/.local
            cp -f tg_ysf.txt /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f nombre_salas_ysf.txt /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f autoarranque.ini /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f memoria_ysf2dmr /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f memoria_dmrplus /home/pi/.local/COPIA_SEGURIDAD/Downloads #22-02-2021
            cp -f memoria_bm /home/pi/.local/COPIA_SEGURIDAD/Downloads #22-02-2021
            cp -f memoria_radio /home/pi/.local/COPIA_SEGURIDAD/Downloads #22-02-2021
            cp -f memoria_especial /home/pi/.local/COPIA_SEGURIDAD/Downloads #22-02-2021
            cp -f memoria_solodstar /home/pi/.local/COPIA_SEGURIDAD/Downloads #22-02-2021
            cp -f memoria_solofusion /home/pi/.local/COPIA_SEGURIDAD/Downloads #22-02-2021
          
            cd  /home/pi/YSFClients/YSFGateway/
            cp -f YSFGateway.ini /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f YSFGateway.ini_1 /home/pi/.local/COPIA_SEGURIDAD/Downloads
        
            cd /home/pi/bluedv/
            cp -f BlueDVconfig.ini /home/pi/.local/COPIA_SEGURIDAD/Downloads

            cd /usr/local/etc/svxlink/
            cp -f svxlink.conf /home/pi/.local/COPIA_SEGURIDAD/Downloads

            cp -f /home/pi/.local/ambe_server.ini  /home/pi/.local/COPIA_SEGURIDAD/Downloads

            cd /usr/local/etc/svxlink/svxlink.d/
            cp -f ModuleEchoLink.conf /home/pi/.local/COPIA_SEGURIDAD/Downloads

            cp /usr/local/etc/opendv/ircddbgateway /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp /usr/local/etc/opendv/dstarrepeater /home/pi/.local/COPIA_SEGURIDAD/Downloads

            #cp /etc/ircddbgateway /home/pi/.local/COPIA_SEGURIDAD/Downloads
            #cp /etc/dstarrepeater /home/pi/.local/COPIA_SEGURIDAD/Downloads

            cd /home/pi
            cp info_panel_control.ini /home/pi/.local/COPIA_SEGURIDAD/Downloads

            cp -f /home/pi/MMDVMHost/MMDVMDMRGateway.ini /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f /home/pi/DMRGateway/DMRGateway.ini /home/pi/.local/COPIA_SEGURIDAD/Downloads

            cp -f /home/pi/MMDVMHost/MMDVMDMR2M17.ini /home/pi/.local/COPIA_SEGURIDAD/Downloads
            cp -f /home/pi/DMR2M17/DMR2M17.ini /home/pi/.local/COPIA_SEGURIDAD/Downloads


cp -f /home/pi/info.ini /home/pi/.local/COPIA_SEGURIDAD/Downloads

cp -f /home/pi/.local/regla2 /home/pi/.local/COPIA_SEGURIDAD/Downloads
cp -f /home/pi/.local/regla3 /home/pi/.local/COPIA_SEGURIDAD/Downloads
cp -f /home/pi/.local/regla4 /home/pi/.local/COPIA_SEGURIDAD/Downloads
cp -f /home/pi/.local/regla5 /home/pi/.local/COPIA_SEGURIDAD/Downloads
cp -f /home/pi/.local/regla6 /home/pi/.local/COPIA_SEGURIDAD/Downloads
cp -f /home/pi/.local/regla7 /home/pi/.local/COPIA_SEGURIDAD/Downloads
cp -f /home/pi/.local/regla8 /home/pi/.local/COPIA_SEGURIDAD/Downloads
cp -f /home/pi/.local/regla9 /home/pi/.local/COPIA_SEGURIDAD/Downloads
cp -f /home/pi/.local/reglaxlx /home/pi/.local/COPIA_SEGURIDAD/Downloads

indicativo=$(awk "NR==2" /opt/MMDVM_Bridge/MMDVM_Bridge.ini)
indicativo=`expr substr $indicativo 10 6`

address_especial=$(awk "NR==70" /opt/MMDVM_Bridge/especial.ini)

id=$(awk "NR==38" /opt/Analog_Bridge/Analog_Bridge.ini)
id=`echo "$id" | tr -d '[[:space:]]'`
id=`expr substr $id 14 7`

id2=$(awk "NR==3" /opt/MMDVM_Bridge/MMDVM_Bridge.ini)
id2=`expr substr $id2 4 9`

Latitude=$(awk "NR==11" /opt/MMDVM_Bridge/MMDVM_Bridge.ini)
Latitude=`expr substr $Latitude 10 10`

Longitude=$(awk "NR==12" /opt/MMDVM_Bridge/MMDVM_Bridge.ini)
Longitude=`expr substr $Longitude 11 10`

port=$(awk "NR==56" /opt/Analog_Bridge/Analog_Bridge.ini)
port=`echo "$port" | tr -d '[[:space:]]'`
port=`expr substr $port 8 5`

location=$(awk "NR==14" /opt/MMDVM_Bridge/MMDVM_Bridge.ini)

url=$(awk "NR==16" /opt/MMDVM_Bridge/MMDVM_Bridge.ini)
url=`expr substr $url 5 30`

password_especial=$(awk "NR==74" /opt/MMDVM_Bridge/especial.ini)

port_especial=$(awk "NR==71" /opt/MMDVM_Bridge/especial.ini)

sala_fcs=$(awk "NR==40" /opt/Analog_Bridge/FCS.ini)
sala_fcs=`echo "$sala_fcs" | tr -d '[[:space:]]'`
sala_fcs=`expr substr $sala_fcs 6 20`

sala_nxdn=$(awk "NR==10" /opt/NXDNClients/NXDNGateway/private/NXDNHosts.txt)

selfcare=$(awk "NR==74" /opt/MMDVM_Bridge/brandmeister_esp.ini)

reflector_dstar=$(awk "NR==18" /etc/ircddbgateway)

# Copia todos los datos de Dvswitch /home/pi/.local/COPIA_SEGURIDAD/Downloads
sed -i "1c $indicativo" /home/pi/.local/COPIA_SEGURIDAD/Downloads/datos_dvswitch
sed -i "2c $address_especial" /home/pi/.local/COPIA_SEGURIDAD/Downloads/datos_dvswitch
sed -i "3c $id" /home/pi/.local/COPIA_SEGURIDAD/Downloads/datos_dvswitch
sed -i "4c $id2" /home/pi/.local/COPIA_SEGURIDAD/Downloads/datos_dvswitch
sed -i "5c $Latitude" /home/pi/.local/COPIA_SEGURIDAD/Downloads/datos_dvswitch
sed -i "6c $Longitude" /home/pi/.local/COPIA_SEGURIDAD/Downloads/datos_dvswitch
sed -i "7c $port" /home/pi/.local/COPIA_SEGURIDAD/Downloads/datos_dvswitch
sed -i "8c $location" /home/pi/.local/COPIA_SEGURIDAD/Downloads/datos_dvswitch
sed -i "9c $url" /home/pi/.local/COPIA_SEGURIDAD/Downloads/datos_dvswitch
sed -i "10c $password_especial" /home/pi/.local/COPIA_SEGURIDAD/Downloads/datos_dvswitch
sed -i "11c $port_especial" /home/pi/.local/COPIA_SEGURIDAD/Downloads/datos_dvswitch
sed -i "12c $sala_fcs" /home/pi/.local/COPIA_SEGURIDAD/Downloads/datos_dvswitch
sed -i "13c $sala_nxdn" /home/pi/.local/COPIA_SEGURIDAD/Downloads/datos_dvswitch
sed -i "14c $selfcare" /home/pi/.local/COPIA_SEGURIDAD/Downloads/datos_dvswitch
sed -i "15c $reflector_dstar" /home/pi/.local/COPIA_SEGURIDAD/Downloads/datos_dvswitch

sudo cp -f /opt/HBlink3/hblink.cfg /home/pi/.local/COPIA_SEGURIDAD/Downloads
sudo cp -f /opt/HBlink3/rules.py /home/pi/.local/COPIA_SEGURIDAD/Downloads
sudo cp -f /opt/HBmonitor/config.py /home/pi/.local/COPIA_SEGURIDAD/Downloads

sudo cp -f /opt/HBmonitor/monitor.py /home/pi/.local/COPIA_SEGURIDAD/Downloads
sudo cp -f /opt/HBmonitor/index_template.html /home/pi/.local/COPIA_SEGURIDAD/Downloads

sudo cp -f /home/pi/info.ini /home/pi/.local/COPIA_SEGURIDAD/Downloads

sudo chmod 777 -R /home/pi/.local/COPIA_SEGURIDAD

