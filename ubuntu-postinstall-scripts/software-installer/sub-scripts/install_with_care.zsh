#!/bin/zsh

# (Open in terminal extension)
wget https://github.com/Stunkymonkey/nautilus-open-any-terminal/releases/download/0.8.1/nautilus-extension-any-terminal_0.8.1-1_all.deb
sudo apt install -y ./nautilus-extension-any-terminal_0.8.1-1_all.deb
rm -f nautilus-extension-any-terminal_0.8.1-1_all.deb

# (Anki)
sudo apt install -y libxcb-xinerama0 libxcb-cursor0 libnss3
wget https://github.com/ankitects/anki/releases/download/25.09/anki-launcher-25.09-linux.tar.zst
tar xaf anki-launcher-25.09-linux.tar.zst
cd anki-launcher-25.09-linux
sudo ./install.sh
anki
cd ..; rm -rf anki-launcher-25.09-linux anki-launcher-25.09-linux.tar.zst

