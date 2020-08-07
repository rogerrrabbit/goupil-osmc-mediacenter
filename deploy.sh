#!/bin/sh

[ "${USER}" != "osmc" ] && echo "Must be run by user 'osmc'" && exit 1

[ $(cat /etc/debian_version | cut -d. -f1) != 9 ] && echo "Made for raspbian stretch only" && exit 1

TMP_DIR=/tmp/deploy.tmp
MOONLIGHT_SCRIPT_DIR=/home/osmc/moonlight/

mkdir -p $TMP_DIR
cd $TMP_DIR

systemctl stop mediacenter

echo "[0] More video memory for moonlight"
echo gpu_mem_1024=320 | sudo tee -a /boot/config.txt

echo "[1] Installing moonlight service"
wget https://raw.githubusercontent.com/rogerrrabbit/goupil-osmc-mediacenter/master/etc/systemd/system/moonlight@.service
wget https://raw.githubusercontent.com/rogerrrabbit/goupil-osmc-mediacenter/master/moonlight/moonlight.py
wget https://raw.githubusercontent.com/rogerrrabbit/goupil-osmc-mediacenter/master/moonlight/moonlight-steam.py
mkdir $MOONLIGHT_SCRIPT_DIR
sudo cp moonlight@.service /etc/systemd/system/
cp moonlight.py $MOONLIGHT_SCRIPT_DIR
cp moonlight-steam.py $MOONLIGHT_SCRIPT_DIR
chmod -R +rx $MOONLIGHT_SCRIPT_DIR
sudo chmod 644 /etc/systemd/system/moonlight@.service

echo "[2] Installing moonlight binary"
echo "deb http://archive.itimmer.nl/raspbian/moonlight stretch main" | sudo tee -a /etc/apt/sources.list
wget http://archive.itimmer.nl/itimmer.gpg
sudo apt-key add itimmer.gpg
sudo apt update
sudo apt -y dist-upgrade
sudo apt -y install moonlight-embedded
moonlight pair
moonlight list

echo "[3] Installing raspotify"
sudo apt -y install curl apt-transport-https
curl -sSL https://dtcooper.github.io/raspotify/key.asc | sudo apt-key add -v -
echo 'deb https://dtcooper.github.io/raspotify jessie main' | sudo tee /etc/apt/sources.list.d/raspotify.list
sudo apt update
sudo apt -y install raspotify
sudo systemctl enable raspotify.service

echo "[4] Installing retrosmc"
wget https://raw.githubusercontent.com/mcobit/retrosmc/master/install-retrosmc.sh
chmod +x install-retrosmc.sh
./install-retrosmc.sh

echo "[5] Installing Amazon VOD repository"
wget https://github.com/Sandmann79/xbmc/releases/download/v1.0.2/repository.sandmann79.plugins-1.0.2.zip
unzip repository.sandmann79.plugins-1.0.2.zip -d /home/osmc/.kodi/addons/
systemctl restart mediacenter
sqlite3 /home/osmc/.kodi/userdata/Database/Addons27.db 'update installed set enabled=1 where addonid=="repository.sandmann79.plugins";'
systemctl restart mediacenter
kodi-send --action="InstallAddon(plugin.video.amazon-test)"

cd -
sudo rm -rf $TMP_DIR
echo "[Done]"

