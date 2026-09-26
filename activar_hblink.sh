sudo systemctl stop hblink
sudo systemctl stop hbmon
sudo systemctl stop parrot

sudo systemctl enable hblink
sudo systemctl enable hbmon
sudo systemctl enable parrot

sudo systemctl restart hblink
sudo systemctl restart hbmon
sudo systemctl restart parrot

sed -i "101c HBLINK=ON" /home/pi/status.ini