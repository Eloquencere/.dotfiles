device_name=$1
device_mac=$2

echo "Device name: $device_name"
echo "Device MAC : $device_mac"

echo -n "Would you like to continue?(y/N) "
read user_choice
if [[ $user_choice =~ ^[Nn]$ ]]; then
    return 1
fi

echo "# Bluetooth device

[Unit]
Description=Auto-connect $device_name
After=bluetooth.target
Requires=bluetooth.target

[Service]
ExecStart=/usr/bin/bluetoothctl connect $device_mac
Type=oneshot

[Install]
WantedBy=default.target
" > ~/.config/systemd/user/autoconnect-bt-${device_name}.service

systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user enable autoconnect-bt-${device_name}.service

