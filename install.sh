#!/usr/bin/env bash
set -euo pipefail

# Install packages
sudo pacman -S --noconfirm \
  flatpak fish fzf zoxide neovim thefuck superfile \
  wireguard-tools satty grim slurp fd go python \
  NetworkManager gcc rustup npm rsync

# Enable NetworkManager
sudo systemctl enable --now NetworkManager

# Ensure directories exist
mkdir -p ~/.local/bin
mkdir -p ~/.config
mkdir -p ~/setup_apps

cd ~/setup_apps

# Install paru
if ! command -v paru >/dev/null; then
  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si --noconfirm
  cd ..
fi

# Install AUR packages
paru -S --noconfirm brave-bin pacseek

# Copy configs 
rsync -a niri-config/nvim/ ~/.config/nvim/
rsync -a niri-config/satty/ ~/.config/satty/
rsync -a niri-config/niri/ ~/.config/niri/
rsync -a niri-config/bin/ ~/.local/bin/

# Make scripts executable
find ~/.local/bin -type f -exec chmod +x {} +

# Install Flatpak apps
flatpak install -y flathub com.github.PintaProject.Pinta
flatpak install -y flathub org.vinegarhq.Sober

# Change shell to fish 
if [ "$SHELL" != "$(which fish)" ]; then
  chsh -s "$(which fish)"
fi
