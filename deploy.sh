#!/bin/sh

[ "${USER}" != "root" ] && echo "Must be run by root" && exit 1

[ $(cat /etc/debian_version | cut -d. -f1) != 9 ] && echo "Made for raspbian stretch only" && exit 1

TMP_DIR=/tmp/deploy.tmp
MOONLIGHT_SCRIPT_DIR=/home/osmc/moonlight/
RETROPIE_SCRIPT_DIR=/home/osmc/retropie/

mkdir -p $TMP_DIR
cd $TMP_DIR

systemctl stop mediacenter

echo "[1] Installing moonlight service"
wget https://raw.githubusercontent.com/rogerrrabbit/goupil-osmc-mediacenter/master/etc/systemd/system/moonlight.service
wget https://raw.githubusercontent.com/rogerrrabbit/goupil-osmc-mediacenter/master/moonlight/moonlight.py
mkdir $MOONLIGHT_SCRIPT_DIR
cp moonlight.service /etc/systemd/system/
cp moonlight.py $MOONLIGHT_SCRIPT_DIR
chmod -R +rx $MOONLIGHT_SCRIPT_DIR
chmod 644 /etc/systemd/system/moonlight.service

echo "[2] Installing moonlight binary"
echo "deb http://archive.itimmer.nl/raspbian/moonlight stretch main" >> /etc/apt/sources.list
wget http://archive.itimmer.nl/itimmer.gpg
apt-key add itimmer.gpg
apt update
apt -y dist-upgrade
apt -y install moonlight-embedded

echo "Note: you'll have to pair moonlight with the PC, logged as osmc: 'moonlight pair'"

echo "[3] Installing raspotify"
apt -y install curl apt-transport-https
curl -sSL https://dtcooper.github.io/raspotify/key.asc | apt-key add -v -
echo 'deb https://dtcooper.github.io/raspotify jessie main' | tee /etc/apt/sources.list.d/raspotify.list
apt update
apt -y install raspotify
systemctl enable raspotify.service

echo "[4] Installing retropie service"
wget https://raw.githubusercontent.com/rogerrrabbit/goupil-osmc-mediacenter/master/etc/systemd/system/retropie.service
wget https://raw.githubusercontent.com/rogerrrabbit/goupil-osmc-mediacenter/master/retropie/retropie.py
mkdir $RETROPIE_SCRIPT_DIR
cp retropie.service /etc/systemd/system/
cp retropie.py $RETROPIE_SCRIPT_DIR
chmod -R +rx $RETROPIE_SCRIPT_DIR
chmod 644 /etc/systemd/system/retropie.service

echo "[5] Installing retropie"
apt -y install libfreeimage-dev libfreetype6-dev libcurl4-openssl-dev cmake libvlc-dev libvlccore-dev vlc rapidjson-dev
wget http://steinerdatenbank.de/software/omxplayer_20180910~7f3faf6~stretch_armhf.deb
dpkg -i omxplayer_201809107f3faf6stretch_armhf.deb
git clone --depth=1 https://github.com/RetroPie/RetroPie-Setup.git
chmod +x RetroPie-Setup/retropie_setup.sh
RetroPie-Setup/retropie_setup.sh

cd -
rm -rf $TMP_DIR
echo "[Done]"

