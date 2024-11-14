function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

croc() {
	if [[ $1 == "recv" ]]; then
		shift
		if [[ $1 == "--here" ]]; then
			shift
            if [[ $1 == "windows" ]]; then
                export CROC_SECRET=$(sqlite3 $XDG_DATA_HOME/croc/croc_collaborators_registry.db "SELECT Transfer_Code FROM internal_comm WHERE ID='$1';")
            elif [[ $1 == "linux" ]]; then
                export CROC_SECRET=$(sqlite3 $XDG_DATA_HOME/croc/croc_collaborators_registry.db "SELECT Transfer_Code FROM internal_comm WHERE ID='$1';")
            else
                export CROC_SECRET=$(sqlite3 $XDG_DATA_HOME/croc/croc_collaborators_registry.db "SELECT Transfer_Code FROM collaborator_catalogue WHERE ID='$1';")
            fi
            command croc && echo "\033[33mTransfer received\033[0m in current working directory"
		else
            if [[ $1 == "windows" ]]; then
                export CROC_SECRET=$(sqlite3 $XDG_DATA_HOME/croc/croc_collaborators_registry.db "SELECT Transfer_Code FROM internal_comm WHERE ID='$1';")
            elif [[ $1 == "linux" ]]; then
                export CROC_SECRET=$(sqlite3 $XDG_DATA_HOME/croc/croc_collaborators_registry.db "SELECT Transfer_Code FROM internal_comm WHERE ID='$1';")
            else
                export CROC_SECRET=$(sqlite3 $XDG_DATA_HOME/croc/croc_collaborators_registry.db "SELECT Transfer_Code FROM collaborator_catalogue WHERE ID='$1';")
            fi
			command croc --out $HOME/croc-inbox && echo "\033[32mTransfer received\033[0m in ~/croc-inbox"
		fi
	elif [[ $1 == "send" ]]; then
        shift
        if [[ $1 == "--help" || $1 == "-h" ]]; then
            command croc send --help
            return
        fi
        if [[ $1 =~ "--delete" ]]; then
            shift
            local ask_user_to_delete=1
        fi
        if [[ $1 == "--win" ]]; then
            shift
            export CROC_SECRET=$(sqlite3 $XDG_DATA_HOME/croc/croc_collaborators_registry.db "SELECT Transfer_Code FROM internal_comm WHERE ID='linux';")
        elif [[ $1 == "--lin" ]]; then
            shift
            export CROC_SECRET=$(sqlite3 $XDG_DATA_HOME/croc/croc_collaborators_registry.db "SELECT Transfer_Code FROM internal_comm WHERE ID='windows';")
        else
            export CROC_SECRET=$(sqlite3 $XDG_DATA_HOME/croc/croc_collaborators_registry.db "SELECT Transfer_Code FROM collaborator_catalogue WHERE ID='$CROC_SELF_TRANSFER_ID';")
        fi
        command croc send "$@"
        if [[ $? -eq 1 || $ask_user_to_delete -ne 1 ]]; then
            return
        fi
        echo -n "\n\033[31mDelete ALL\033[0m the above transfered data?(y/N)"
        read delete_confirmation
        if [[ $delete_confirmation =~ ^[Yy]$ ]]; then
            rm -rf "$@"
        fi
    else
        command croc "$@"
	fi
}

# usbip
usbip() {
    if [[ $1 == "show" ]]; then
        shift
        lsusbip
	elif [[ $1 == "attach" ]]; then
		shift
		sudo usbip attach --remote=$SERVER_IP --busid "$@"
	elif [[ $1 == "detach" ]]; then
		shift
		sudo usbip detach --port "$@"
	else
		command usbip "$@"
	fi
}
lsusbip() {
	local server_devices usbip_port_output
	local busid device_name vid_pid port_number
  
	IFS=$'\n' read -r -d '' -A server_devices < <(usbip list --remote=$SERVER_IP | grep --regexp "^\s+[-0-9]+:")
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
