#!/usr/bin/env bash
# Mostra os keybinds do Hyprland num fzf (aberto num kitty flutuante pelo SUPER+SHIFT+/).
# Digite pra filtrar; Esc ou Enter fecha.
"$(dirname "$0")/keybinds.py" | fzf \
    --no-sort --layout=reverse --prompt="keybinds > " \
    --header="Esc/Enter fecha" --no-info --bind=enter:abort
