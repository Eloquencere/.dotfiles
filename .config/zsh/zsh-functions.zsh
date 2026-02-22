croc() {
	if [[ $1 == "recv" ]]; then
		shift
		if [[ $1 == "--here" ]]; then
			shift
            export CROC_SECRET=$(sqlite3 $ZDOTDIR/personal/croc_collaborators_registry.db "SELECT Transfer_Code FROM collaborator_catalogue WHERE ID='$1';")
            command croc && echo "\033[33mTransfer received\033[0m in current working directory"
		else
            export CROC_SECRET=$(sqlite3 $ZDOTDIR/personal/croc_collaborators_registry.db "SELECT Transfer_Code FROM collaborator_catalogue WHERE ID='$1';")
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
        export CROC_SECRET=$(sqlite3 $ZDOTDIR/personal/croc_collaborators_registry.db "SELECT Transfer_Code FROM collaborator_catalogue WHERE ID='$CROC_SELF_TRANSFER_ID';")
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

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

