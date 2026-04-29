#!/bin/zsh

# (Anki)
anki_version='25.09'
sudo apt install -y libxcb-xinerama0 libxcb-cursor0 libnss3
wget https://github.com/ankitects/anki/releases/download/$anki_version/anki-launcher-$anki_version-linux.tar.zst
tar xaf anki-launcher-$anki_version-linux.tar.zst
cd anki-launcher-$anki_version-linux
sudo ./install.sh
anki
cd ..; rm -rf anki-launcher-$anki_version-linux anki-launcher-$anki_version-linux.tar.zst

