# moonlight-osmc-launcher
0. Install moonlight for OSMC (https://github.com/irtimmer/moonlight-embedded/wiki/Packages)
1. Install the systemd service file (don't forget chmod 644)
2. Install the python script service launcher in home directory
3. Create a RunScript launcher in Kodi
4. Pair moonlight with the PC

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
