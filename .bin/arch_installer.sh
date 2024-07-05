# Arch install Guide
# Wifi Setup
ip addr show
iwctl
station <wifi-interface-name> get-networks
exit
iwctl --passphrase "<passwd>" station <Wifi-Name> connect <wifi-interface-name>

# Install steps
pacstrap -K /mnt base linux linux-firmware sof-firmware  
genfstab -U -p /mnt > /mnt/etc/fstab
arch-chroot /mnt

# Computer name - "dev-machine"
# user - "Eloquencer"

pacman -S base-devel neovim
pacman -S zsh
pacman -S amd-ucode grub networkmanager
systemctl enable NetworkManager

export EDITOR=nvim
alias n=nvim

# setup and config grub

pacman -S xorg
pacman -S gnome gnome-extra gnome-tweaks gdm

# disable grub screen on boot
sudo nvim /etc/default/grub 
# set grub timeout style equal to hidden

# References
# https://wiki.archlinux.org/title/Installation_guide
# https://www.youtube.com/watch?v=68z11VAYMS8
# https://www.youtube.com/watch?v=YC7NMbl4goo
# https://www.youtube.com/watch?v=FxeriGuJKTM
