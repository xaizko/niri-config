sudo pacman -S flatpak fish fzf zoxide neovim thefuck superfile wireguard-tools satty grim slurp fd go python NetworkManager gcc rustup npm 

sudo systemctl enable --now NetworkManager

mkdir -p ~/setup_apps && cd ~/setup_apps
git clone https://aur.archlinux.org/paru.git
cd paru && makepkg -si --noconfirm

paru -S brave-bin pacseek

cd ~/setup_apps/
cp -r niri-config/nvim/ ~/.config/
cp -r niri-config/bin/* ~/.local/bin/
chmod +x ~/.local/bin/*

chsh -s $(which fish)
