#!/bin/sh
sudo systemctl stop mediacenter
/usr/bin/moonlight stream
sudo systemctl start mediacenter
