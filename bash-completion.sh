#!/bin/bash

# Remove the existing .config/ziggy directory if it exists
rm -rf ~/.config/ziggy

# Make the .config/ziggy directory and navigate to
mkdir ~/.config/ziggy && cd ~/.config/ziggy

# Download the _zig file to the .config/ziggy directory
wget https://raw.githubusercontent.com/Byte-Cats/shell-completions/master/_zig

# Add the .config/ziggy directory to the $fpath, remove duplicates
echo "fpath=(~/.config/ziggy \$fpath)" >> ~/.bashrc
sed -i '$!N; /^\(.*\)\n\1$/!P; D' ~/.bashrc

# Source the ~/.bashrc file to update the current terminal
source ~/.bashrc
