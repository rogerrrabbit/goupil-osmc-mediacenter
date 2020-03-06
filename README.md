# moonlight-osmc-launcher
0. Install moonlight for OSMC (https://github.com/irtimmer/moonlight-embedded/wiki/Packages)
1. Install the systemd service file (don't forget chmod 644)
2. Install the python script service launcher in home directory
3. Create a RunScript launcher in Kodi
4. Pair moonlight with the PC

# retropie
apt -y install libfreeimage-dev libfreetype6-dev libcurl4-openssl-dev cmake libvlc-dev libvlccore-dev vlc rapidjson-dev
wget http://steinerdatenbank.de/software/omxplayer_20180910~7f3faf6~stretch_armhf.deb
dpkg -i omxplayer_20180910~7f3faf6~stretch_armhf.deb
git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git
cd RetroPie-Setup
chmod +x retropie_setup.sh
./retropie_setup.sh

# raspotify
sudo apt-get -y install curl apt-transport-https
curl -sSL https://dtcooper.github.io/raspotify/key.asc | sudo apt-key add -v -
echo 'deb https://dtcooper.github.io/raspotify jessie main' | sudo tee /etc/apt/sources.list.d/raspotify.list
sudo apt-get update
sudo apt-get -y install raspotify
sudo nano /etc/default/raspotify
sudo systemctl enable raspotify.service

# other backup tool
https://github.com/graham8/osmc-backup/blob/master/README.md
