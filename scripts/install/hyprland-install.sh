#!/bin/bash

source "$(dirname "$0")/../utils.sh"
# --- Browsers ---
install firefox
install chromium

# --- 1password ---
if ! command -V 1password &> /dev/null; then
	curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --import
	git clone https://aur.archlinux.org/1password.git
	cd 1password
	makepkg -si
else
	echo "1password already installed"
fi


# --- Audio ---
install pipewire
install pipewire-pulse
install pipewire-alsa
install wireplumber
install spotify-launcher
install pavucontrol
install pamixer

# --- Audio Service Setup ---
audio_services=("pipewire", "pipewire-pulse", "wireplumber")

for service in "${audio_services[@]}"; do
	if ! systemctl --user is-active --quiet "$service"; then
		echo "$service is already running, skipping ..."
	else
		echo "Enabling and starting $service"
		systemctl --user enable "$service"
		systemctl --user start "$service"
	fi
done


# --- Dock & Status bar ---
install waybar
yay_install nwg-dock-hyprland

# --- Rofi ---
install rofi-wayland
yay_install elephant
yay_install elephant-desktopapplications
yay_install walker

# --- Login Screen ---
yay_install greetd
yay_install greetd-tuigreet

# --- Lock Screen ---
install hyprlock
install hypridle

# --- File Manager ---
install nautilus
install gvfs
install tumbler
install ffmpegthumbnailer

# --- Other Apps ---
yay_install slack-desktop
yay_install warp-terminal-bin
yay_install cursor-bin
install fastfetch

# --- Claude Code ---
if command -v claude &> /dev/null; then
	echo "Claude Code is already installed, skipping ..."
else
	echo "Installing Claude Code ..."
	curl -fsSL https://claude.ai/install.sh | sh
	echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
fi

# --- Docker ---
install docker
install docker-compose
install docker-buildx

if ! systemctl --user is-active --quiet docker; then
	echo "Docker is already running, skipping ..."
else
	echo "Enabling and starting docker ..."
	systemctl --user enable docker
	systemctl --user start docker
fi

sudo usermod -aG docker $USER

# --- Fonts ---
install ttf-jetbrains-mono
install ttf-nerd-fonts-symbols
install noto-fonts
yay_install ttf-jetbrains-mono-nerd
install noto-fonts-emoji
install ttf-dejavu
install ttf-liberation
install ttf-fira-code

# ---- Node ---
if ! command -v nvm >/dev/null 2>&1; then
  echo "nvm - installing ..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
else
  echo "nvm already installed, skipping"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

nvm install --lts

# --- Open AI Codex ---
if ! command -v codex >/dev/null 2>&1; then
  echo "Codex - installing ..."
  npm install -g @openai/codex
else
  echo "Code already installed, skipping"
fi

# --- Wallpaper and Screensaver ---
install swww

# --- rclone for backups ---
install rclone

