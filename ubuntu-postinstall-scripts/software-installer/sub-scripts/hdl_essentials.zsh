#!/bin/zsh
set -o errexit \
    -o nounset \
    -o pipefail

sudo nala install -y verilator
flatpak install --assumeyes flathub "com.github.reds.LogisimEvolution"
cpanm --sudo Verilog::Std

pip install wavedrom
pip install fusesoc xilinx-language-server
pip install pyslang pyuvm 
pip install cocotb cocotb-bus cocotb-coverage cocotb-test
# export PYTHONPATH=$(python3 -c "import site; print(site.getsitepackages()[0])"):$PYTHONPATH
# https://github.com/cocotb/cocotb/wiki/Further-Resources#extension-modules-cocotbext

# Maybe never
# pip install drawpyo python-statemachine[diagrams,io]

