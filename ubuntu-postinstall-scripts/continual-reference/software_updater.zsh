sudo nala full-upgrade -y
sudo snap refresh

flatpak update --assumeyes
flatpak uninstall --unused --delete-data --assumeyes

nix-channel --update
cd ~/.config/home-manager
nix profile upgrade --all; nix flake update
home-manager switch --flake .
home-manager news &> /dev/null
nix-collect-garbage --delete-old; nix store gc
cd -

zinit update --all

echo "Update your nvim plugins & researt your machine"

# # Update nix pkg manager
# sudo $(which nix-env) --install --file '<nixpkgs>' --attr nix -I nixpkgs=channel:nixpkgs-unstable
# sudo systemctl daemon-reload
# sudo systemctl restart nix-daemon

# # Firmware updater
# sudo fwupdmgr refresh
# sudo fwupdmgr get-devices
# sudo fwupdmgr get-updates

# sudo auto-cpufreq --update

