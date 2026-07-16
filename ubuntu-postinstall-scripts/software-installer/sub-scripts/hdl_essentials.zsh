#!/bin/zsh
set -o errexit \
    -o nounset \
    -o pipefail

sudo nala install -y verilator
flatpak install --assumeyes flathub "com.github.reds.LogisimEvolution"

pip install fusesoc xilinx-language-server
pip install coco-tb pyslang
pip install wavedrom # NOTE: Add the others too
# Maybe never
# pip install drawpyo python-statemachine[diagrams,io]

