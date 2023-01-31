#!/bin/bash

# Make the .config/ziggy directory
mkdir -p ~/.config/ziggy

# Download the _zig file to the .config/ziggy directory
curl https://raw.githubusercontent.com/ziglang/shell-completions/master/_zig -o ~/.config/ziggy/_zig

# Add the .config/ziggy directory to the $fpath
echo "source \"~/.config/ziggy/_zig\"" >> /.bashrc

# Source the ~/.bashrc file to update the current terminal
source ~/.bashrc
