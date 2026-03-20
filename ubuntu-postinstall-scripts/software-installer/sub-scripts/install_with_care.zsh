#!/bin/zsh

# (Open in terminal extension)
nautilus_any_terminal_version='0.8.1'
wget https://github.com/Stunkymonkey/nautilus-open-any-terminal/releases/download/$nautilus_any_terminal_version/nautilus-extension-any-terminal_$nautilus_any_terminal_version-1_all.deb
sudo nala install ./nautilus-extension-any-terminal_$nautilus_any_terminal_version-1_all.deb
rm -f nautilus-extension-any-terminal_$nautilus_any_terminal_version-1_all.deb

# (Anki)
anki_version='25.09'
sudo apt install -y libxcb-xinerama0 libxcb-cursor0 libnss3
wget https://github.com/ankitects/anki/releases/download/$anki_version/anki-launcher-$anki_version-linux.tar.zst
tar xaf anki-launcher-$anki_version-linux.tar.zst
cd anki-launcher-$anki_version-linux
sudo ./install.sh
anki
cd ..; rm -rf anki-launcher-$anki_version-linux anki-launcher-$anki_version-linux.tar.zst

