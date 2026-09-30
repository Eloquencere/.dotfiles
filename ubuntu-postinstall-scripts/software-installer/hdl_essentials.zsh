#!/bin/zsh

sudo nala install -y verilator

sudo nala install -y tio
sudo usermod -aG dialout $USER

sudo snap install logisim-evolution-snapcraft
cpanm --sudo Verilog::Std

# # export PYTHONPATH=$(python3 -c "import site; print(site.getsitepackages()[0])"):$PYTHONPATH
# # https://github.com/cocotb/cocotb/wiki/Further-Resources#extension-modules-cocotbext

# Maybe never
# pip install drawpyo python-statemachine[diagrams,io] xilinx-language-server

