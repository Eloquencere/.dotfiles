#!/bin/zsh

# (Anki)
version='25.09'
sudo apt install -y libxcb-xinerama0 libxcb-cursor0 libnss3
wget https://github.com/ankitects/anki/releases/download/$version/anki-launcher-$version-linux.tar.zst
tar xaf anki-launcher-$version-linux.tar.zst
cd anki-launcher-$version-linux
sudo ./install.sh
anki
cd ..; rm -rf anki-launcher-$version-linux anki-launcher-$version-linux.tar.zst

