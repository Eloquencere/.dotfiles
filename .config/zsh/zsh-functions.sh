# Extracting archives
exct() {
	if [ -f "$1" ]; then
		case $1 in
			*.tbz2)    tar xjf $1 ;;
			*.tgz)     tar xzf $1 ;;
			*.tar)     tar xf $1 ;;
			*.tar.bz2) tar xjf $1 ;;
			*.tar.gz)  tar xzf $1 ;;
			*.tar.xz)  tar xf $1 ;;
			*.tar.zst) unzstd $1 ;;
			*.7z)      7z x $1 ;;
			*.zip)     unzip $1 ;;
			*.bz2)     bzip2 $1 ;;
			*.gz)      gunzip $1 ;;
			*.Z)       uncompress $1 ;;
			*.rar)     unrar x $1 ;;
			*.deb)     ar x $1 ;;
			*)         echo "'$1' cannot be extracted via ex()" ;;
		esac
 	fi
}

# usbip
SERVER_IP=1
usbip() {
	if [[ $1 == "attach" ]]; then
		shift
		sudo usbip attach --remote=$SERVER_IP "$@"
	elif [[ $1 == "detach" ]]; then
		shift
		sudo usbip detach "$@"
	else
		command usbip "$@"
	fi
}
lsusbip() {
	local server_devices usbip_port_output
 	local busid device_name vid_pid port_number
  
	IFS=$'\n' read -r -d '' -A server_devices < <(usbip list --remote=$SERVER_IP | grep --regexp "^\s+[-0-9]+:") # might need to add local IFS=
	usbip_port_output=$(usbip port 2>/dev/null)
	printf "Devices from %s\n" "$SERVER_IP"
	printf "%-10s %-50s %-10s\n" "BUSID" "DEVICE" "PORT"
	local regex="^\s+([-0-9]+):\s+(.*)\s+(\(.*\))$"
	for server_device in $server_devices; do
		if [[ $server_device =~ $regex ]]; then
			busid=$match[1]
			device_name=$match[2]
			vid_pid=$match[3]
		fi
	done
	port_number=$(echo "$usbip_port_output" | grep --before-context=1 "$vid_pid" | sed --silent '1s/.*\([-0-9]\+\):.*/\1/p')
	printf "%-10s %-50s %-10s\n" "$busid" "$device_name" "$port_number"
}
