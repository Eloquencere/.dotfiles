# compdef _croc

_croc() {
	local line state

	_arguments -C \
		"1: :->cmds" \
		"*::arg:->args"

	case "$state" in
		cmds)
			_values "croc command" \
				"send[send local files to a receiver]" \
				"recv[receive a transfer from a sender]"
			;;
		args)
			case $line[1] in
				send)
					_croc_send_cmd
				;;
				recv)
					_croc_recv_cmd
				;;
			esac
			;;
	esac
}

_croc_recv_cmd() {
	local line state

	_arguments -C \
		"1: :->cmds" \
		"*::arg:->args"
	
	case "$state" in
		cmds)
			_values "croc project contacts" \
				${(@k)CROC_TRANSFER_CODES[@]/"self"}
			;;
	esac
}

_croc_send_cmd() {
	# add --zip & --text & --git
}

