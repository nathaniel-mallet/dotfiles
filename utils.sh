#!/bin/bash

# Helper function for install messages
install() {
	if pacman -Q $1 &> /dev/null; then
		echo "$1 - skipped (already installed)"
	else
		echo "installing $1 ..."
		sudo pacman -S --noconfirm $1
	fi
}
