curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

cp ~/setup_apps/niri-config/fish/config.fish ~/.config/fish/config.fish

fisher install PatrickF1/fzf.fish

export XDG_CURRENT_DESKTOP=niri
export XDG_SESSION_DESKTOP=niri
export XDG_SESSION_TYPE=wayland
