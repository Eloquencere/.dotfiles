croc() {
	if [[ $1 == "send" ]]; then
		shift
		export CROC_SECRET=${CROC_TRANSFER_CODES[self]}
		command croc send "$@"
	elif [[ $1 == "recv" ]]; then
		shift
		export CROC_SECRET=${CROC_TRANSFER_CODES[$1]} 
		command croc
	else
		command croc "$@"
	fi
}

archive() {
	if [[ "$1" == "list" ]]; then
		shift
		if [ -f "$1" ];then 
			case $1 in
				*.tar.bz2) tar	        tjf	 $1 | \tree -C --fromfile . | bat --style=plain ;;
				*.tbz2)    tar	        tjf	 $1 | \tree -C --fromfile . | bat --style=plain ;;
				*.bz2)     tar          tjf	 $1 | \tree -C --fromfile . | bat --style=plain ;;
				*.tar.gz)  tar	        tzf	 $1 | \tree -C --fromfile . | bat --style=plain ;;
				*.tgz)     tar	        tzf	 $1 | \tree -C --fromfile . | bat --style=plain ;;
				*.tar.xz)  tar          tf	 $1 | \tree -C --fromfile . | bat --style=plain ;;
				*.tar)     tar	        tf	 $1 | \tree -C --fromfile . | bat --style=plain ;;
				*.tar.zst) tar --zstd  -tf	 $1 | \tree -C --fromfile . | bat --style=plain ;;
				*.7z)      7za	        l    -ba $1 ;;
				*.zip)     unzip       -l	 $1 ;;
				*.rar)     7za		l    -ba $1 ;;
				*.gz)      gunzip     --list 	 $1 ;;
				*.deb)     ar           t        $1 ;;
				*)         echo "'$1' cannot be listed via archive" ;;
			esac
		fi
	elif [[ "$1" == "create" ]]; then
		shift
		case $1 in
			*.tar.bz2) tar         cjvf $1 ${@:2} ;;
			*.tbz2)    tar         cjvf $1 ${@:2} ;;
			*.bz2)     tar         cjvf $1 ${@:2} ;;
			*.tar.gz)  tar         czvf $1 ${@:2} ;;
			*.tgz)     tar         czvf $1 ${@:2} ;;
			*.tar.xz)  tar	       cvf  $1 ${@:2} ;;
			*.tar)     tar	       cvf  $1 ${@:2} ;;
			*.tar.zst) tar --zstd -cf   $1 ${@:2} ;;
			*.7z)      7za	       a    $1 ${@:2} ;;
			*.zip)     7za  -tzip  a    $1 ${@:2} ;;
			*.rar)	   7za         a    $1 ${@:2} ;;
			*)         echo "'$1' cannot be created via archive" ;;
		esac
	elif [[ "$1" == "extract" ]];then
		shift
		if [ -f "$1" ]; then
			case $1 in
				*.tar.bz2) tar         xjvf $1 --one-top-level ;;
				*.tbz2)    tar         xjvf $1 --one-top-level ;;
				*.bz2)     tar         xjvf $1 --one-top-level ;;
				*.tar.gz)  tar         xzvf $1 --one-top-level ;;
				*.tgz)     tar         xzvf $1 --one-top-level ;;
				*.tar.xz)  tar         xvf  $1 --one-top-level ;;
				*.tar)     tar         xvf  $1 --one-top-level ;;
				*.tar.zst) tar --zstd -xf   $1 --one-top-level ;;
				*.7z)      7za         x    $1 ;;
				*.zip)     unzip            $1 ;;
				*.rar)     7za	       x    $1 ;;
				*.gz)      gunzip           $1 ;;
				*.Z)       uncompress       $1 ;;
				*.deb)     ar          x    $1 ;;
				*)         echo "'$1' cannot be extracted via archive" ;;
			esac
		fi
	elif [[ $1 == "help" ]]; then
		echo
		echo "This command is used to compress, decompress and list the contents of compressed files.
		Options:
		- list: List all the contents of the compressed file/folder
		- create: Compress a file/folder
		- extract: Extract a compressed file/folder
		- help: Documentation and examples

		Examples:
		To compress a file/folder,
		archive create <Compressed File Name> <File/Folder Name>

		To decompress a compressed file.
		archive extract <Compressed File Name>

		To list the contents of a compressed file,
		archive list <Compressed File Name>
		"
	fi
}

# usbip
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
 	if [ ${#server_devices[@]} -eq 1 ]; then
  		return
   	fi
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
