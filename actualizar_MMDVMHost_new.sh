#!/bin/bash
                    cd /home/pi/MMDVMHost

                    HOY=$(date +%Y%m%d)
                    FIJA="const char* VERSION = "\"
                    PI="V106EXP"\"
                    HOY1=$HOY$PI
                    PUNTO=";"   
                    
                    sed -i "22c $FIJA$HOY1$PUNTO" /home/pi/MMDVMHost/Version.h

                    make clean
                    make -f Makefile.Pi.OLED
                 
                    
                    sed -i "5c Duplex=0" /home/pi/MMDVMHost/MMDVM.ini
                    sed -i "52c UARTSpeed=115200" /home/pi/MMDVMHost/MMDVM.ini
                    sed -i "229c Type=Direct" /home/pi/MMDVMHost/MMDVM.ini
                    sed -i "231c # LocalPort=62032" /home/pi/MMDVMHost/MMDVM.ini
                    sed -i "234c Password=PASSWORD" /home/pi/MMDVMHost/MMDVM.ini

                 # Crea los ejecutables para estas aplicaciones 
                    
                    cp MMDVMHost MMDVMBM
                    cp MMDVMHost MMDVMPLUS
                    cp MMDVMHost MMDVMDSTAR
                    cp MMDVMHost MMDVMFUSION
                    cp MMDVMHost DMR2NXDN
                    cp MMDVMHost DMR2YSF
                    cp MMDVMHost MMDVMDMR2M17
                    cp MMDVMHost MMDVMNXDN
                    cp MMDVMHost MMDVMESPECIAL
                    cp MMDVMHost MMDVMDMRGATEWAY                 
                    
                    # Crea el fichero para que arranque NextionDriver ==================
                    # cp MMDVM.ini MMDVM.ini_NextionDriver

                    # Crea los ficheros .ini y Memorias ==================
                    cp MMDVM.ini MMDVM.ini_original
                    cp MMDVM.ini MMDVM.ini_copia
                    cp MMDVM.ini MMDVM.ini_copia2
                    cp MMDVM.ini MMDVM.ini_copia3

                    cp MMDVM.ini MMDVMBM.ini
                    cp MMDVM.ini MMDVMBM.ini_copia
                    cp MMDVM.ini MMDVMBM.ini_copia2
                    cp MMDVM.ini MMDVMBM.ini_copia3

                    cp MMDVM.ini MMDVMPLUS.ini
                    cp MMDVM.ini MMDVMPLUS.ini_copia
                    cp MMDVM.ini MMDVMPLUS.ini_copia2
                    cp MMDVM.ini MMDVMPLUS.ini_copia3

                    cp MMDVM.ini MMDVMDSTAR.ini
                    cp MMDVM.ini MMDVMDSTAR.ini_copia
                    cp MMDVM.ini MMDVMDSTAR.ini_copia2
                    cp MMDVM.ini MMDVMDSTAR.ini_copia3

                    cp MMDVM.ini MMDVMFUSION.ini
                    cp MMDVM.ini MMDVMFUSION.ini_copia
                    cp MMDVM.ini MMDVMFUSION.ini_copia2
                    cp MMDVM.ini MMDVMFUSION.ini_copia3  

                    cp MMDVM.ini MMDVMESPECIAL.ini
                    cp MMDVM.ini MMDVMESPECIAL.ini_copia
                    cp MMDVM.ini MMDVMESPECIAL.ini_copia2
                    cp MMDVM.ini MMDVMESPECIAL.ini_copia3                

                    cp MMDVM.ini MMDVMNXDN.ini
                    
                    cp MMDVM.ini TODOS_LOS_INIS.ini

                    cp MMDVM.ini MMDVMDMR2YSF.ini
                    
                    cp MMDVM.ini MMDVMDMR2NXDN.ini

                    cp MMDVM.ini MMDVMDMR2M17.ini
                  
                    cp MMDVM.ini MMDVMDMRGateway.ini 
                    
                    sed -i "52c UARTSpeed=115200" /home/pi/MMDVMHost/MMDVMDMRGateway.ini
                    sed -i "229c Type=Gateway" /home/pi/MMDVMHost/MMDVMDMRGateway.ini
                    sed -i "231c LocalPort=62032" /home/pi/MMDVMHost/MMDVMDMRGateway.ini
                    
                    sed -i "52c UARTSpeed=115200" /home/pi/MMDVMHost/MMDVMDMR2YSF.ini
                    sed -i "231c LocalPort=62032" /home/pi/MMDVMHost/MMDVMDMR2YSF.ini
                    sed -i "231c LocalPort=62032" /home/pi/MMDVMHost/MMDVMDMR2NXDN.ini
                    sed -i "231c LocalPort=62037" /home/pi/MMDVMHost/MMDVMDMR2M17.ini

                    sudo chmod 777 -R /home/pi/MMDVMHost
                
                    exit;
