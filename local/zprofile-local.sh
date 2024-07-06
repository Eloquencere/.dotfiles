# Starship
export STARSHIP_CONFIG=${XDG_CONFIG_HOME}/starship/starship.toml

# Pyenv
export PYENV_ROOT="\$HOME/.pyenv"
[[ -d PYENV_ROOT/bin ]] && export PATH="\$PYENV_ROOT/bin":$PATH
eval "$(pyenv init -)"

# Rust
# export PATH=$HOME/.cargo/bin:$PATH

# QuestaSim
export PATH="$TOOLS_HOME/Mentor_Graphics/questasim/linux_x86_64":$PATH
export PATH="$TOOLS_HOME/Mentor_Graphics/questasim/RUVM_2021.2":$PATH
export LM_LICENSE_FILE="$XDG_DATA_HOME/QuestaSim/license.dat":$LM_LICENSE_FILE

# Symbiyosys
export PATH="$TOOLS_HOME/YosysHQ/oss-cad-suite/bin":$PATH

# Vivado
source $TOOLS_HOME/Xilinx/Vivado/2024.1/settings64.sh
source $TOOLS_HOME/Xilinx/Vitis/2024.1/settings64.sh

# usbip
function usbip() {
	if [[ \$1 == "attach" ]]; then
		shift
		sudo usbip attach --remote=\$SERVER_IP "\$@"
	elif [[ \$1 == "detach" ]]; then
		shift
		sudo usbip detach "\$@"
	else
		command usbip "\$@"
	fi
}
function lsusbip() {
	IFS=$'\n' read -r -d '' -A server_devices < <(usbip list --remote=\$SERVER_IP | grep --regexp "^\s+[-0-9]+:") # might need to add local IFS=
	usbip_port_output=$(usbip port 2>/dev/null)
	printf "Devices from %s\n" "\$SERVER_IP"
	printf "%-10s %-50s %-10s\n" "BUSID" "DEVICE" "PORT"
	regex="^\s+([-0-9]+):\s+(.*)\s+(\(.*\))$"
	for server_device in \$server_devices; do
		if [[ \$server_device =~ \$regex ]]; then
			busid=\$match[1]
			device_name=\$match[2]
			vid_pid=\$match[3]
		fi
	done
	port_number=$(echo "\$usbip_port_output" | grep --before-context=1 "\$vid_pid" | sed --silent '1s/.*\([-0-9]\+\):.*/\1/p')
	printf "%-10s %-50s %-10s\n" "\$busid" "\$device_name" "\$port_number"
}
