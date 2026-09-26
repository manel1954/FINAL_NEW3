#!/bin/bash
clear
#Colores  
ROJO="\033[1;31m"
VERDE="\033[1;32m"
BLANCO="\033[1;37m"
AMARILLO="\033[1;33m"
CIAN="\033[1;36m"
GRIS="\033[0m"

printf "${GRIS}"

cd /opt
sudo rm -R HBlink3
git clone https://github.com/lz5pn/HBlink3
sudo mv /opt/HBlink3/ /opt/backup/
sudo mv /opt/backup/HBlink3/ /opt/
sudo mv /opt/backup/HBmonitor/ /opt/
sudo mv /opt/backup/dmr_utils3/ /opt/
sudo rm -r /opt/backup/

sleep 2

cd /opt/dmr_utils3
sudo chmod +x install.sh
./install.sh

clear
printf "${CIAN}"

echo "=================================================================================="
echo "                                INSTALANDO HBLINK3                                "
echo "=================================================================================="
printf "${GRIS}"
sleep 2

cd /opt/HBlink3
sudo cp hblink-SAMPLE.cfg hblink.cfg
sudo cp rules-SAMPLE.py rules.py

#Crear servicio para el hblink  
sudo cat > /lib/systemd/system/hblink.service <<- "EOF"
[Unit]
Description=Start HBlink
After=multi-user.target
[Service]
ExecStart=/usr/bin/python3 /opt/HBlink3/bridge.py
[Install]
WantedBy=multi-user.target
EOF

sleep 2

sudo systemctl daemon-reload
sudo systemctl enable hblink

#Instalar Parrot
sudo chmod +x playback.py

#Crear directorio  /var/log/hblink si no está creado
mkdir /var/log/hblink

#Crear servicio para el parrot 
sudo cat > /lib/systemd/system/parrot.service <<- "EOF"
[Unit]
Description=HB bridge all Service
After=network-online.target syslog.target
Wants=network-online.target
[Service]
StandardOutput=null
WorkingDirectory=/opt/HBlink3
RestartSec=3
ExecStart=/usr/bin/python3 /opt/HBlink3/playback.py -c /opt/HBlink3/playback.cfg
Restart=on-abort
[Install]
WantedBy=multi-user.target
EOF

sleep 2

sudo systemctl enable parrot.service
sudo systemctl start parrot.service

/usr/bin/python3 -m pip install --upgrade pip
sudo pip install --upgrade pyopenssl

sleep 2

#Instalar de nuevo web monitor para HBLink
cd /opt/HBmonitor
sudo chmod +x install.sh
./install.sh

sudo cp config_SAMPLE.py config.py

sleep 2

#Start monitor service
sudo cp /opt/HBmonitor/utils/hbmon.service /lib/systemd/system/
sudo systemctl daemon-reload
sudo systemctl stop hbmon.service
sudo systemctl disable hbmon.service
sudo systemctl enable hbmon.service
sudo systemctl start hbmon.service

cd /opt

#HBmonitor
sudo rm -R HBmonitor
git clone http://github.com/manel1954/HBmonitor

sleep 1

sudo chmod 777 -R  /opt/HBmonitor

#hblink              
cd /var/www/html
sudo rm -R hblink
git clone http://github.com/manel1954/hblink

sleep 1

sudo chmod 777 -R  /var/www/html/hblink

sleep 2


#Crear hlink.cfg  
sudo cat > /opt/HBlink3/hblink.cfg <<- "EOF"
# PROGRAM-WIDE PARAMETERS GO HERE
# PATH - working path for files, leave it alone unless you NEED to change it
# PING_TIME - the interval that peers will ping the master, and re-try registraion
#           - how often the Master maintenance loop runs
# MAX_MISSED - how many pings are missed before we give up and re-register
#           - number of times the master maintenance loop runs before de-registering a peer
#
# ACLs:
#
# Access Control Lists are a very powerful tool for administering your system.
# But they consume packet processing time. Disable them if you are not using them.
# But be aware that, as of now, the configuration stanzas still need the ACL
# sections configured even if you're not using them.
#
# REGISTRATION ACLS ARE ALWAYS USED, ONLY SUBSCRIBER AND TGID MAY BE DISABLED!!!
#
# The 'action' May be PERMIT|DENY
# Each entry may be a single radio id, or a hypenated range (e.g. 1-2999)
# Format:
# 	ACL = 'action:id|start-end|,id|start-end,....'
#		--for example--
#	SUB_ACL: DENY:1,1000-2000,4500-60000,17
#
# ACL Types:
# 	REG_ACL: peer radio IDs for registration (only used on HBP master systems)
# 	SUB_ACL: subscriber IDs for end-users
# 	TGID_TS1_ACL: destination talkgroup IDs on Timeslot 1
# 	TGID_TS2_ACL: destination talkgroup IDs on Timeslot 2
#
# ACLs may be repeated for individual systems if needed for granularity
# Global ACLs will be processed BEFORE the system level ACLs
# Packets will be matched against all ACLs, GLOBAL first. If a packet 'passes'
# All elements, processing continues. Packets are discarded at the first
# negative match, or 'reject' from an ACL element.
#
# If you do not wish to use ACLs, set them to 'PERMIT:ALL'
# TGID_TS1_ACL in the global stanza is used for OPENBRIDGE systems, since all
# traffic is passed as TS 1 between OpenBridges
[GLOBAL]
PATH: ./
PING_TIME: 5
MAX_MISSED: 3
USE_ACL: True
REG_ACL: PERMIT:ALL
SUB_ACL: DENY:1
TGID_TS1_ACL: PERMIT:ALL
TGID_TS2_ACL: PERMIT:ALL


# NOT YET WORKING: NETWORK REPORTING CONFIGURATION
#   Enabling "REPORT" will configure a socket-based reporting
#   system that will send the configuration and other items
#   to a another process (local or remote) that may process
#   the information for some useful purpose, like a web dashboard.
#
#   REPORT - True to enable, False to disable
#   REPORT_INTERVAL - Seconds between reports
#   REPORT_PORT - TCP port to listen on if "REPORT_NETWORKS" = NETWORK
#   REPORT_CLIENTS - comma separated list of IPs you will allow clients
#       to connect on. Entering a * will allow all.
#
# ****FOR NOW MUST BE TRUE - USE THE LOOPBACK IF YOU DON'T USE THIS!!!****
[REPORTS]
REPORT: True
REPORT_INTERVAL: 60
REPORT_PORT: 4321
REPORT_CLIENTS: 127.0.0.1


# SYSTEM LOGGER CONFIGURAITON
#   This allows the logger to be configured without chaning the individual
#   python logger stuff. LOG_FILE should be a complete path/filename for *your*
#   system -- use /dev/null for non-file handlers.
#   LOG_HANDLERS may be any of the following, please, no spaces in the
#   list if you use several:
#       null
#       console
#       console-timed
#       file
#       file-timed
#       syslog
#   LOG_LEVEL may be any of the standard syslog logging levels, though
#   as of now, DEBUG, INFO, WARNING and CRITICAL are the only ones
#   used.
#
[LOGGER]
LOG_FILE: /tmp/hblink.log
LOG_HANDLERS: console-timed
LOG_LEVEL: DEBUG
LOG_NAME: HBlink

# DOWNLOAD AND IMPORT SUBSCRIBER, PEER and TGID ALIASES
# Ok, not the TGID, there's no master list I know of to download
# This is intended as a facility for other applcations built on top of
# HBlink to use, and will NOT be used in HBlink directly.
# STALE_DAYS is the number of days since the last download before we
# download again. Don't be an ass and change this to less than a few days.
[ALIASES]
TRY_DOWNLOAD: True
PATH: ./
PEER_FILE: peer_ids.json
SUBSCRIBER_FILE: subscriber_ids.json
TGID_FILE: talkgroup_ids.json
#PEER_URL: https://www.radioid.net/api/dmr/repeater/?country=united%%20states
#SUBSCRIBER_URL: https://www.radioid.net/api/dmr/user/?country=united%%20states
PEER_URL: https://www.radioid.net/static/rptrs.json
SUBSCRIBER_URL: https://www.radioid.net/static/users.json
STALE_DAYS: 7

# OPENBRIDGE INSTANCES - DUPLICATE SECTION FOR MULTIPLE CONNECTIONS
# OpenBridge is a protocol originall created by DMR+ for connection between an
# IPSC2 server and Brandmeister. It has been implemented here at the suggestion
# of the Brandmeister team as a way to legitimately connect HBlink to the
# Brandemiester network.
# It is recommended to name the system the ID of the Brandmeister server that
# it connects to, but is not necessary. TARGET_IP and TARGET_PORT are of the
# Brandmeister or IPSC2 server you are connecting to. PASSPHRASE is the password
# that must be agreed upon between you and the operator of the server you are
# connecting to. NETWORK_ID is a number in the format of a DMR Radio ID that
# will be sent to the other server to identify this connection.
# other parameters follow the other system types.
#
# ACLs:
# OpenBridge does not 'register', so registration ACL is meaningless.
# OpenBridge passes all traffic on TS1, so there is only 1 TGID ACL.
# Otherwise ACLs work as described in the global stanza
[OBP-1]
MODE: OPENBRIDGE
ENABLED: False
IP:
PORT: 62035
NETWORK_ID: 3129100
PASSPHRASE: password
TARGET_IP: 1.2.3.4
TARGET_PORT: 62035
USE_ACL: True
SUB_ACL: DENY:1
TGID_ACL: PERMIT:ALL

# MASTER INSTANCES - DUPLICATE SECTION FOR MULTIPLE MASTERS
# HomeBrew Protocol Master instances go here.
# IP may be left blank if there's one interface on your system.
# Port should be the port you want this master to listen on. It must be unique
# and unused by anything else.
# Repeat - if True, the master repeats traffic to peers, False, it does nothing.
#
# MAX_PEERS -- maximun number of peers that may be connect to this master
# at any given time. This is very handy if you're allowing hotspots to
# connect, or using a limited computer like a Raspberry Pi.
#
# ACLs:
# See comments in the GLOBAL stanza
[MASTER]
MODE: MASTER
ENABLED: True
REPEAT: True
MAX_PEERS: 10
EXPORT_AMBE: False
IP: 
PORT: 54000
PASSPHRASE: PASSWORD
GROUP_HANGTIME: 5
USE_ACL: True
REG_ACL: DENY:1
SUB_ACL: DENY:1
TGID_TS1_ACL: PERMIT:ALL
TGID_TS2_ACL: PERMIT:ALL

# PEER INSTANCES - DUPLICATE SECTION FOR MULTIPLE PEERS
# There are a LOT of errors in the HB Protocol specifications on this one!
# MOST of these items are just strings and will be properly dealt with by the program
# The TX & RX Frequencies are 9-digit numbers, and are the frequency in Hz.
# Latitude is an 8-digit unsigned floating point number.
# Longitude is a 9-digit signed floating point number.
# Height is in meters
# Setting Loose to True relaxes the validation on packets received from the master.
# This will allow HBlink to connect to a non-compliant system such as XLXD, DMR+ etc.
#
# ACLs:
# See comments in the GLOBAL stanza
[PARROT]
MODE: PEER
ENABLED: True
LOOSE: False
EXPORT_AMBE: False
IP: 
PORT: 54001
MASTER_IP: 127.0.0.1
MASTER_PORT: 54100
PASSPHRASE: password
CALLSIGN: PARROT
RADIO_ID: 9990
RX_FREQ: 436000000
TX_FREQ: 436000001
TX_POWER: 25
COLORCODE: 1
SLOTS: 2
LATITUDE: 0.0
LONGITUDE: -0.0
HEIGHT: 209
LOCATION: Ciudad
DESCRIPTION: This is a cool Hotspot
URL: www.associacioader.com
SOFTWARE_ID: 20220219
PACKAGE_ID: MMDVM_ADER
GROUP_HANGTIME: 5
OPTIONS:
USE_ACL: True
SUB_ACL: DENY:1
TGID_TS1_ACL: PERMIT:ALL
TGID_TS2_ACL: PERMIT:ALL







#regla 2
[ADER-2]
MODE: PEER
ENABLED: True
LOOSE: True
EXPORT_AMBE: False
IP: 
PORT: 54002
MASTER_IP: 62.171.178.202
MASTER_PORT: 54202
PASSPHRASE: Password
CALLSIGN: EAXXXX
RADIO_ID: 123456789
RX_FREQ: 436000000
TX_FREQ: 436000001
TX_POWER: 25
COLORCODE: 1
SLOTS: 2
LATITUDE: 0.0
LONGITUDE: -0.0
HEIGHT: 209
LOCATION: Ciudad
DESCRIPTION: This is a cool Hotspot
URL: www.associacioader.com
SOFTWARE_ID: 20220219
PACKAGE_ID: MMDVM_ADER
GROUP_HANGTIME: 5
OPTIONS: 
USE_ACL: True
REG_ACL: DENY:1
SUB_ACL: DENY:1
TGID_TS1_ACL: PERMIT:ALL
TGID_TS2_ACL: PERMIT:ALL


















#[MASTERXXX]
#MODE: MASTER
#ENABLED: True
#REPEAT: True
#MAX_PEERS: 10
#EXPORT_AMBE: False
#IP: 
#PORT: 55000
#PASSPHRASE: PASSWORD
#GROUP_HANGTIME: 5
#USE_ACL: True
#REG_ACL: DENY:1
#SUB_ACL: DENY:1
#TGID_TS1_ACL: PERMIT:ALL
#TGID_TS2_ACL: PERMIT:ALL


































#regla 3
[P-TGIF]
MODE: PEER
ENABLED: True
LOOSE: True
EXPORT_AMBE: False
IP: 
PORT: 54003
MASTER_IP: tgif.network
MASTER_PORT: 62031
PASSPHRASE: passw0rd
CALLSIGN: EAXXXX
RADIO_ID: 123456789
RX_FREQ: 436000000
TX_FREQ: 436000001
TX_POWER: 25
COLORCODE: 1
SLOTS: 2
LATITUDE: 0.0
LONGITUDE: -0.0
HEIGHT: 209
LOCATION: Ciudad
DESCRIPTION: This is a cool Hotspot
URL: www.associacioader.com
SOFTWARE_ID: 20220219
PACKAGE_ID: MMDVM_ADER
GROUP_HANGTIME: 5
OPTIONS: 
USE_ACL: True
REG_ACL: DENY:1
SUB_ACL: DENY:1
TGID_TS1_ACL: PERMIT:ALL
TGID_TS2_ACL: PERMIT:ALL



































































#regla 4
[DMR+4374]
MODE: PEER
ENABLED: True
LOOSE: True
EXPORT_AMBE: False
IP: 
PORT: 54004
MASTER_IP: 80.211.226.37
MASTER_PORT: 55555
PASSPHRASE: PASSWORD
CALLSIGN: EAXXXX
RADIO_ID: 123456789
RX_FREQ: 436000000
TX_FREQ: 436000001
TX_POWER: 25
COLORCODE: 1
SLOTS: 2
LATITUDE: 0.0
LONGITUDE: -0.0
HEIGHT: 209
LOCATION: Ciudad
DESCRIPTION: This is a cool Hotspot
URL: www.associacioader.com
SOFTWARE_ID: 20220219
PACKAGE_ID: MMDVM_ADER
GROUP_HANGTIME: 5
OPTIONS: StartRef=4374;RelinkTime=15
USE_ACL: True
REG_ACL: DENY:1
SUB_ACL: DENY:1
TGID_TS1_ACL: PERMIT:ALL
TGID_TS2_ACL: PERMIT:ALL



































































#regla 5
[DMR+21465]
MODE: PEER
ENABLED: True
LOOSE: True
EXPORT_AMBE: False
IP: 
PORT: 54005
MASTER_IP: 212.237.3.141
MASTER_PORT: 55555
PASSPHRASE: PASSWORD
CALLSIGN: EAXXXX
RADIO_ID: 123456789
RX_FREQ: 436000000
TX_FREQ: 436000001
TX_POWER: 25
COLORCODE: 1
SLOTS: 2
LATITUDE: 0.0
LONGITUDE: -0.0
HEIGHT: 209
LOCATION: Ciudad
DESCRIPTION: This is a cool Hotspot
URL: www.associacioader.com
SOFTWARE_ID: 20220219
PACKAGE_ID: MMDVM_ADER
GROUP_HANGTIME: 5
OPTIONS: StartRef=4000;RelinkTime=15;TS2_1=21465
USE_ACL: True
REG_ACL: DENY:1
SUB_ACL: DENY:1
TGID_TS1_ACL: PERMIT:ALL
TGID_TS2_ACL: PERMIT:ALL



































































#regla 6
[DMR-CENTRAL]
MODE: PEER
ENABLED: True
LOOSE: True
EXPORT_AMBE: False
IP: 
PORT: 54006
MASTER_IP: dmr.pa7lim.nl
MASTER_PORT: 55555
PASSPHRASE: passw0rd
CALLSIGN: EAXXXX
RADIO_ID: 123456789
RX_FREQ: 436000000
TX_FREQ: 436000001
TX_POWER: 25
COLORCODE: 1
SLOTS: 2
LATITUDE: 0.0
LONGITUDE: -0.0
HEIGHT: 209
LOCATION: Ciudad
DESCRIPTION: This is a cool Hotspot
URL: www.associacioader.com
SOFTWARE_ID: 20220219
PACKAGE_ID: MMDVM_ADER
GROUP_HANGTIME: 5
OPTIONS: 
USE_ACL: True
REG_ACL: DENY:1
SUB_ACL: DENY:1
TGID_TS1_ACL: PERMIT:ALL
TGID_TS2_ACL: PERMIT:ALL



































































#regla 7
[DMR+4371]
MODE: PEER
ENABLED: True
LOOSE: True
EXPORT_AMBE: False
IP: 
PORT: 54007
MASTER_IP: 217.61.97.204
MASTER_PORT: 55555
PASSPHRASE: PASSWORD
CALLSIGN: EAXXXX
RADIO_ID: 123456789
RX_FREQ: 436000000
TX_FREQ: 436000001
TX_POWER: 25
COLORCODE: 1
SLOTS: 2
LATITUDE: 0.0
LONGITUDE: -0.0
HEIGHT: 209
LOCATION: Ciudad
DESCRIPTION: This is a cool Hotspot
URL: www.associacioader.com
SOFTWARE_ID: 20220219
PACKAGE_ID: MMDVM_ADER
GROUP_HANGTIME: 5
OPTIONS: StartRef=4371;RelinkTime=15
USE_ACL: True
REG_ACL: DENY:1
SUB_ACL: DENY:1
TGID_TS1_ACL: PERMIT:ALL
TGID_TS2_ACL: PERMIT:ALL



































































#regla 8
[DMR+4373]
MODE: PEER
ENABLED: True
LOOSE: True
EXPORT_AMBE: False
IP: 
PORT: 54008
MASTER_IP: 89.36.222.146
MASTER_PORT: 55555
PASSPHRASE: PASSWORD
CALLSIGN: EAXXXX
RADIO_ID: 123456789
RX_FREQ: 436000000
TX_FREQ: 436000001
TX_POWER: 25
COLORCODE: 1
SLOTS: 2
LATITUDE: 0.0
LONGITUDE: -0.0
HEIGHT: 209
LOCATION: Ciudad
DESCRIPTION: This is a cool Hotspot
URL: www.associacioader.com
SOFTWARE_ID: 20220219
PACKAGE_ID: MMDVM_ADER
GROUP_HANGTIME: 5
OPTIONS: StartRef=4373;RelinkTime=15
USE_ACL: True
REG_ACL: DENY:1
SUB_ACL: DENY:1
TGID_TS1_ACL: PERMIT:ALL
TGID_TS2_ACL: PERMIT:ALL



































































#regla 9
[BRANDMEISTER]
MODE: PEER
ENABLED: True
LOOSE: True
EXPORT_AMBE: False
IP: 
PORT: 54009
MASTER_IP: master.spain-dmr.es
MASTER_PORT: 62031
PASSPHRASE: Selfcare
CALLSIGN: EAXXXX
RADIO_ID: 123456789
RX_FREQ: 434100000
TX_FREQ: 434100001
TX_POWER: 25
COLORCODE: 1
SLOTS: 2
LATITUDE: 0.0
LONGITUDE: -0.0
HEIGHT: 209
LOCATION: Ciudad
DESCRIPTION: This is a cool Hotspot
URL: www.associacioader.com
SOFTWARE_ID: 20220219
PACKAGE_ID: MMDVM_ADER
GROUP_HANGTIME: 5
OPTIONS: 
USE_ACL: True
REG_ACL: DENY:1
SUB_ACL: DENY:1
TGID_TS1_ACL: PERMIT:ALL
TGID_TS2_ACL: PERMIT:ALL



































































#regla 10
[XLX266-Z]
MODE: PEER
ENABLED: True
LOOSE: True
EXPORT_AMBE: False
IP: 
PORT: 54010
MASTER_IP: 62.171.178.202
MASTER_PORT: 62030
PASSPHRASE: 
CALLSIGN: EAXXXX
RADIO_ID: 1234567
RX_FREQ: 436000000
TX_FREQ: 436000001
TX_POWER: 25
COLORCODE: 1
SLOTS: 2
LATITUDE: 0.0
LONGITUDE: -0.0
HEIGHT: 209
LOCATION: Ciudad
DESCRIPTION: This is a cool Hotspot
URL: www.associacioader.com
SOFTWARE_ID: 20220219
PACKAGE_ID: MMDVM_ADER
GROUP_HANGTIME: 5
OPTIONS:
USE_ACL: True
REG_ACL: DENY:1
SUB_ACL: DENY:1
TGID_TS1_ACL: PERMIT:ALL
TGID_TS2_ACL: PERMIT:ALL

EOF

sleep 2

#Crear rules.pi
sudo cat > /opt/HBlink3/rules.py <<- "EOF"
'''
THIS EXAMPLE WILL NOT WORK AS IT IS - YOU MUST SPECIFY YOUR OWN VALUES!!!

This file is organized around the "Conference Bridges" that you wish to use. If you're a c-Bridge
person, think of these as "bridge groups". You might also liken them to a "reflector". If a particular
system is "ACTIVE" on a particular conference bridge, any traffid from that system will be sent
to any other system that is active on the bridge as well. This is not an "end to end" method, because
each system must independently be activated on the bridge.

The first level (e.g. "WORLDWIDE" or "STATEWIDE" in the examples) is the name of the conference
bridge. This is any arbitrary ASCII text string you want to use. Under each conference bridge
definition are the following items -- one line for each HBSystem as defined in the main HBlink
configuration file.

    * SYSTEM - The name of the sytem as listed in the main hblink configuration file (e.g. hblink.cfg)
        This MUST be the exact same name as in the main config file!!!
    * TS - Timeslot used for matching traffic to this confernce bridge
    * TGID - Talkgroup ID used for matching traffic to this conference bridge
    * ON and OFF are LISTS of Talkgroup IDs used to trigger this system off and on. Even if you
        only want one (as shown in the ON example), it has to be in list format. None can be
        handled with an empty list, such as " 'ON': [] ".
    * TO_TYPE is timeout type. If you want to use timers, ON means when it's turned on, it will
        turn off afer the timout period and OFF means it will turn back on after the timout
        period. If you don't want to use timers, set it to anything else, but 'NONE' might be
        a good value for documentation!
    * TIMOUT is a value in minutes for the timout timer. No, I won't make it 'seconds', so don't
        ask. Timers are performance "expense".
    * RESET is a list of Talkgroup IDs that, in addition to the ON and OFF lists will cause a running
        timer to be reset. This is useful   if you are using different TGIDs for voice traffic than
        triggering. If you are not, there is NO NEED to use this feature.
'''

BRIDGES = {
        'PARROT': [
            {'SYSTEM': 'MASTER', 'TS': 2, 'TGID': 9990, 'ACTIVE': True, 'TIMEOUT': 2, 'TO_TYPE': 'NONE', 'ON': [], 'OFF': [],'RESET': []},
            {'SYSTEM': 'PARROT', 'TS': 2, 'TGID': 9990, 'ACTIVE': True, 'TIMEOUT': 2, 'TO_TYPE': 'NONE', 'ON': [], 'OFF': [],'RESET': []},
        
        
        #regla 2
],    
'ADER-2': [
{'SYSTEM': 'MASTER', 'TS': 2, 'TGID': 6565, 'ACTIVE': True, 'TIMEOUT': 2, 'TO_TYPE': 'NONE',  'ON': [6565], 'OFF': [86565], 'RESET': []},
{'SYSTEM': 'ADER-2', 'TS': 2, 'TGID': 6565, 'ACTIVE': True, 'TIMEOUT': 2, 'TO_TYPE': 'NONE',  'ON': [], 'OFF': [], 'RESET': []},
        
        
        
        
        
        #regla 3
],    
'P-TGIF': [
{'SYSTEM': 'MASTER', 'TS': 2, 'TGID': 4021, 'ACTIVE': True, 'TIMEOUT': 2, 'TO_TYPE': 'NONE',  'ON': [4021], 'OFF': [84021], 'RESET': []},
{'SYSTEM': 'P-TGIF', 'TS': 2, 'TGID': 21465, 'ACTIVE': True, 'TIMEOUT': 2, 'TO_TYPE': 'NONE',  'ON': [], 'OFF': [], 'RESET': []},
        
        
        
        
        
        #regla 4
], 
'DMR+4374': [
{'SYSTEM': 'MASTER', 'TS': 2, 'TGID': 4374, 'ACTIVE': True, 'TIMEOUT': 2, 'TO_TYPE': 'NONE',  'ON': [4374], 'OFF': [84374], 'RESET': []},
{'SYSTEM': 'DMR+4374', 'TS': 2, 'TGID': 9, 'ACTIVE': True, 'TIMEOUT': 2, 'TO_TYPE': 'NONE',  'ON': [], 'OFF': [], 'RESET': []},
        
        
        
        
        
        #regla 5
],  
'DMR+21465': [
{'SYSTEM': 'MASTER', 'TS': 2, 'TGID': 4025, 'ACTIVE': True, 'TIMEOUT': 2, 'TO_TYPE': 'NONE',  'ON': [4025], 'OFF': [84025], 'RESET': []},
{'SYSTEM': 'DMR+21465', 'TS': 2, 'TGID': 21465, 'ACTIVE': True, 'TIMEOUT': 2, 'TO_TYPE': 'NONE',  'ON': [], 'OFF': [], 'RESET': []},
        
        
        
        
        
        #regla 6
],
'DMR-CENTRAL': [
{'SYSTEM': 'MASTER', 'TS': 2, 'TGID': 4022, 'ACTIVE': True, 'TIMEOUT': 2, 'TO_TYPE': 'NONE',  'ON': [4022], 'OFF': [84022], 'RESET': []},
{'SYSTEM': 'DMR-CENTRAL', 'TS': 2, 'TGID': 21465, 'ACTIVE': True, 'TIMEOUT': 2, 'TO_TYPE': 'NONE',  'ON': [], 'OFF': [], 'RESET': []},
        
        
        
        
        
        #regla 7
],
'DMR+4371': [
{'SYSTEM': 'MASTER', 'TS': 2, 'TGID': 4371, 'ACTIVE': True, 'TIMEOUT': 2, 'TO_TYPE': 'NONE',  'ON': [4371], 'OFF': [84371], 'RESET': []},
{'SYSTEM': 'DMR+4371', 'TS': 2, 'TGID': 9, 'ACTIVE': True, 'TIMEOUT': 2, 'TO_TYPE': 'NONE',  'ON': [], 'OFF': [], 'RESET': []},
        
        
        
        
        
        #regla 8
],
'DMR+4373': [
{'SYSTEM': 'MASTER', 'TS': 2, 'TGID': 4373, 'ACTIVE': True, 'TIMEOUT': 2, 'TO_TYPE': 'NONE',  'ON': [4373], 'OFF': [84373], 'RESET': []},
{'SYSTEM': 'DMR+4373', 'TS': 2, 'TGID': 9, 'ACTIVE': True, 'TIMEOUT': 2, 'TO_TYPE': 'NONE',  'ON': [], 'OFF': [], 'RESET': []},
        
        
        
        
        
        #regla 9
],
'BRANDMEISTER': [
{'SYSTEM': 'MASTER', 'TS': 2, 'TGID': 21465, 'ACTIVE': True, 'TIMEOUT': 2, 'TO_TYPE': 'NONE',  'ON': [21465], 'OFF': [821465], 'RESET': []},
{'SYSTEM': 'BRANDMEISTER', 'TS': 2, 'TGID': 21465, 'ACTIVE': True, 'TIMEOUT': 2, 'TO_TYPE': 'NONE',  'ON': [], 'OFF': [], 'RESET': []},
    




        #regla 10
],
'XLX266-Z': [
{'SYSTEM': 'MASTER', 'TS': 2, 'TGID': 4026, 'ACTIVE': True, 'TIMEOUT': 10, 'TO_TYPE': 'NONE',  'ON': [4026], 'OFF': [84026], 'RESET': []},
{'SYSTEM': 'XLX266-Z', 'TS': 2, 'TGID': 4026, 'ACTIVE': True, 'TIMEOUT': 10, 'TO_TYPE': 'NONE',  'ON': [4026], 'OFF': [], 'RESET': []},
{'SYSTEM': 'XLX266-Z', 'TS': 2, 'TGID': 9, 'ACTIVE': True, 'TIMEOUT': 10, 'TO_TYPE': 'NONE',  'ON': [], 'OFF': [], 'RESET': []},

        ]
  
}

if __name__ == '__main__':
    from pprint import pprint
    pprint(BRIDGES)
EOF

cd /home/pi

ifconfig | grep -oP 'inet \K[\d.]+' > ip.txt

ip=$(awk "NR==1" /home/pi/ip.txt)

clear
printf "${CIAN}"

echo "=================================================================================="
echo "              Introduce el nombre del Dashboard ej. Dashboard EA3EIZ              "
echo "=================================================================================="
printf "${GRIS}"
read dashboard
sudo sed -i "1c REPORT_NAME     = \'$dashboard\'" /opt/HBmonitor/config.py

printf "${GRIS}"

sleep 1

sudo sed -i "74c background-image: url(http://$ip/hblink/images/fondo_hblink3.png);" /opt/HBmonitor/index_template.html

# Suponiendo que la variable $ip ya está definida
# Extraer la última parte de la IP
last_part=$(echo "$ip" | awk -F. '{print $4}')

# Contar la cantidad de dígitos
length=${#last_part}

# Crear la variable ip_buena con el formato adecuado
if [ "$length" -eq 3 ]; then
    ip_hblink="7$last_part"
elif [ "$length" -eq 2 ]; then
    ip_hblink="70$last_part"
elif [ "$length" -eq 1 ]; then
    ip_hblink="700$last_part"
else
    ip_hblink="ERROR"
fi

# Mostrar el resultado
echo "$ip_hblink"
sudo sed -i "9c WEB_SERVER_PORT = $ip_hblink" /opt/HBmonitor/config.py
sudo sed -i "4c header(\"Location:http://$ip:$port\");" /var/www/html/hblink/dashboard.php
sudo sed -i "2c header(\"Location:http://$ip:$port\");" /var/www/html/hblink/dashboard_sin_cambios.php
sudo sed -i "11c header(\"Location:http://$ip:$port\");" /var/www/html/hblink/aplicar_cambios_en_todas_las_reglas.php
sudo sed -i "307c \<a href=\"http://$ip/hblink/editar_reglas.php\"\>CONFIGURACION ACTIVAR DESACTIVAR REGLAS\</a\>" /opt/HBmonitor/index_template.html
sudo sed -i "308c \<a href=\"http://$ip/hblink/editar_reglas_cambios.php\"\>CREAR EDITAR PARAMETROS REGLAS\</a\>" /opt/HBmonitor/index_template.html
sudo sed -i "311c \<a href=\"http://$ip/hblink/cambia_nombre_dashboard.php\"\>CAMBIA NOMBRE DASHBOARD\</a>" /opt/HBmonitor/index_template.html


sudo sed -i "312c \<a href=\"http://$ip/hblink/cambia_peers.php\"\>CAMBIA PEERS\</a\>" /opt/HBmonitor/index_template.html
sudo sed -i "313c \<a href=\"http://$ip/hblink/cambia_repeat.php\"\>CAMBIA REPEAT\</a\>" /opt/HBmonitor/index_template.html
sudo sed -i "314c \<a href=\"http://$ip/hblink/cambia_puentes.php\"\>CAMBIA PUENTES\</a\>" /opt/HBmonitor/index_template.html
sudo sed -i "315c \<a href=\"http://$ip/hblink/restaurar_servicios.php\"\>RESTAURAR SERVICIOS\</a\>" /opt/HBmonitor/index_template.html




sudo sed -i "316c \<a href=\"http://$ip/panel_control_experimental_v106/index.php\"\>PANEL DE CONTROL\</a>" /opt/HBmonitor/index_template.html


sudo sed -i "286c \<img class=\"imagen\" src=\"http://$ip/hblink/images/hotspots.png\" width=\"80\" alt=\"Imagen\">" /opt/HBmonitor/index_template.html
sudo sed -i "292c \<img class=\"imagen\" src=\"http://$ip/hblink/images/repetidores.png\" width=\"80\" alt=\"Imagen\">" /opt/HBmonitor/index_template.html
sudo sed -i "298c \<img class=\"imagen\" src=\"http://$ip/hblink/images/puentes.png\" width=\"80\" alt=\"Imagen\">" /opt/HBmonitor/index_template.html

# SIGUIENTE LINEA AÑADIDA 28-10-2024
sudo sed -i "166c \<a href=\"http://$ip:$port/panel_control_experimental_v106/index.php\" class=\"btn btn-warning btn-sm mt-auto\"\>DASHBOARD HBLINK3\</a>" /var/www/html/panel_control/panel_control.php

sudo chmod 777 -R /opt/HBmonitor
sudo chmod 777 -R /opt/HBlink3

sudo sed -i "3c HBLINK3_INSTALADO=OK" /var/www/html/dvs/config/estado-dvswitch-hblink.txt

sudo systemctl restart hblink & systemctl restart hbmon & systemctl restart parrot & 

clear
printf "${VERDE}"

echo "=================================================================================="
echo "                      HBLINK3 INSTALADO SATISFACTORIAMENTE                        "
echo "=================================================================================="
printf "${GRIS}"
sleep 3
clear
exit


