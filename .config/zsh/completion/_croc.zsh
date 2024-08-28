#compdef croc

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

	declare -a local_list
	while IFS='|' read -r Name ID Designation; do
		local_list+=("${ID}[${Designation} > ($Name)]")
	done <<< $(sqlite3 $ZDOTDIR/.confidential/croc_collaborators_registry.db "SELECT Name,ID,Designation FROM collaborator_catalogue WHERE Self=0;")

	_arguments -C \
		"1: :->cmds" \
		"*::arg:->args"
	
	case "$state" in
		cmds)
			_values "croc project contacts" \
				${local_list[@]}
			;;
	esac
}

_croc_send_cmd() {
	_path_files
	# add --zip & --text & --git
}

compdef _croc croc
