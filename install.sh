#!/usr/bin/env bash
set -euo pipefail

# Install DMS
curl -fsSL https://install.danklinux.com | sh

# Install packages
sudo pacman -S --noconfirm \
  flatpak fish fzf zoxide neovim thefuck superfile \
  wireguard-tools satty grim slurp fd go python \
  networkmanager gcc rustup npm rsync fastfetch \
  unzip zip mpv bat tree nano

#Set up Rust
rustup default stable

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
paru -S --noconfirm brave-bin pacseek visual-studio-code-bin vesktop \
                    catppuccin-cursors-macchiato

# Copy configs 
rsync -a niri-config/nvim/ ~/.config/nvim/
rsync -a niri-config/satty/ ~/.config/satty/
rsync -a niri-config/niri/ ~/.config/niri/
rsync -a niri-config/DankMaterialShell ~/.config/DankMaterialShell/
rsync -a niri-config/bin/ ~/.local/bin/

# Make scripts executable
find ~/.local/bin -type f -exec chmod +x {} +

# Install Flatpak apps
flatpak install -y flathub com.github.PintaProject.Pinta
flatpak install -y flathub org.vinegarhq.Sober

# Update Launcher To Add Flatpak Apps
sudo ln -sf /var/lib/flatpak/exports/share/applications/*.desktop /usr/share/applications/ 2>/dev/null || true
sudo update-desktop-database /usr/share/applications || true

# Change shell to fish 
if [ "$SHELL" != "$(which fish)" ]; then
  chsh -s "$(which fish)"
fi
