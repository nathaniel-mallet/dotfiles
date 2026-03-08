#!/bin/bash

source "$(dirname "$0")/utils.sh"

# Git
install git

# Neovim
install neovim

# zsh
install zsh
if [ $SHELL != "$(which zsh)" ]; then
	echo "Setting zsh as default shell ..."
	chsh -s $(which zsh)
else
	echo "zsh is already the default shell, skipping"
fi

# oh my zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	echo "Installing Oh My Zsh ..."
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
	echo "Oh My Zsh - skipped (already installed)"
fi

# ssh
install openssh
install ksshaskpass

# create default directories
dirs=(
"$HOME/Documents"
"$HOME/Downloads"
"$HOME/Projects"
"$HOME/Pictures"
)
for dir in "${dirs[@]}"; do
	if [ ! -d "$dir" ]; then
		echo "Creating $dir ..."
		mkdir -p "$dir"
	else
		echo "$dir - skipped (already exists"
	fi
done

# tmux
install tmux

# yay
if ! command -v yay &> /dev/null; then
	echo "Installing yay ..."
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si --noconfirm
	cd ..
	rm -rf yay
else
	echo "yay - skipped (already installed)"
fi 

# --- Terminal Tools ---
install fzf # Fuzzy Find
install ripgrep
install fd
install bat # cat replacement
install eza # ls replacement
install zoxide
install unzip
install zip

# --- System tools ---
install btop
install man-db
install tree
install base-devel

# --- Nvidia drivers ---
install nvidia-open
install nvidia-utils
install nvidia-settings
sudo mkinitcpio -P
echo "You should reboot the computer at this point to load the Nvidia driver. Once that's done, run nvidia-smi to verify that the driver is working"

# --- Hyprland & Dependencies ---
install hyprland
install xorg-xwayland
install xdg-desktop-portal-hyprland
install qt5-wayland
install qt6-wayland
install kitty
install wl-clipboard
install polkit-gnome
