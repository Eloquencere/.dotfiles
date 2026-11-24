#!/bin/zsh

cd "$(dirname "${(%):-%x}")" # change directory to script location

sudo sh -c "nala full-upgrade -y; nala autoremove --purge -y; nala clean"
sudo snap refresh
app-manager --update-all
flatpak update --assumeyes; flatpak uninstall --unused --delete-data --assumeyes

# nix profile upgrade --all # updates home-manager
cd $XDG_CONFIG_HOME/home-manager
read -qt 10 "?Run 'nix flake update' (y/N)? " && nix flake update nixpkgs nixpkgs-unstable
home-manager switch --flake .
home-manager news &> /dev/null
nix-collect-garbage --delete-old
cd -

mise upgrade && mise cache clear && mise prune -y
pip install --upgrade pip && pip cache purge

zinit self-update
zinit update --all

hermes update --yes
agy update

fwupdmgr refresh --force && fwupdmgr update -y
sudo journalctl --vacuum-time=7d

echo "Update Lazy plugins & Mason, restart your machine"

# # Vocalinux (official installer; rebuilds whisper.cpp with Vulkan for GPU)
# curl -fsSL https://raw.githubusercontent.com/VocaHQ/vocalinux/main/install.sh \
#   -o /tmp/vocalinux-update.sh && \
# bash /tmp/vocalinux-update.sh --auto
# rm -f /tmp/vocalinux-update.sh

# # Update nix pkg manager (Manually)
# sudo $(which nix-env) --install --file '<nixpkgs>' --attr nix -I nixpkgs=channel:nixpkgs-unstable
# sudo systemctl daemon-reload
# sudo systemctl restart nix-daemon

# # XDM 9 (deb only: no apt repo, snap or flatpak to upgrade it, so poll GitHub releases)
# xdm_tag="$(curl -fsSL -H 'Accept: application/vnd.github+json' \
#   https://api.github.com/repos/subhra74/xdm/releases/latest \
#   | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -1)"
# xdm_new="${xdm_tag#v}"
# xdm_cur="$(dpkg-query -W -f '${Version}' xdm-app 2>/dev/null)"
# if [[ -n $xdm_cur && $xdm_new != "$xdm_cur" ]] && \
#    [[ $(printf '%s\n%s\n' "$xdm_cur" "$xdm_new" | sort -V | tail -1) == "$xdm_new" ]]; then
#     wget -O /tmp/xdm-app.deb \
#       "https://github.com/subhra74/xdm/releases/download/$xdm_tag/xdm-app_${xdm_new}_$(dpkg --print-architecture).deb"
#     sudo nala install -y /tmp/xdm-app.deb
#     rm -f /tmp/xdm-app.deb
# fi

# # Run manually
# uv cache prune
# ./fetch-oss-cad-suite.sh

# # Not installed
# sudo auto-cpufreq --update

