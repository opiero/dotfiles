#!/usr/bin/env bash
# Escolhe quais efeitos o screensaver sorteia (menu do walker). Esc volta/sai.
set -uo pipefail
dir=~/.config/hypr/screensaver
conf=$dir/effects.conf

pick() { local p=$1; shift; printf '%s\n' "$@" | walker --dmenu --placeholder "$p" 2>/dev/null; }

preview() {
    kitty --class floating-default -o background=#000000 -o background_opacity=1 -e sh -c \
        "clear; ~/.local/bin/tte -i $dir/logo.txt --canvas-width 0 --canvas-height 0 \
         --anchor-canvas c --anchor-text c --no-eol $1; sleep 2" >/dev/null 2>&1
}

while true; do
    on=$(grep -cvE '^[[:space:]]*(#|$)' "$conf")
    mapfile -t lines < <(grep -vE '^# (Efeitos|Lista)' "$conf" | grep -v '^$' | while read -r l; do
        if [[ $l == \#* ]]; then printf '󰄱  %s\n' "$(sed -E 's/^#[[:space:]]*//' <<<"$l")"; else printf '󰄲  %s\n' "$l"; fi
    done)
    choice=$(pick "Efeitos ligados: $on — escolha um" "󰐊  Testar o screensaver" "${lines[@]}") || exit 0
    [[ -z $choice ]] && exit 0
    if [[ $choice == *Testar* ]]; then setsid -f "$dir/launch.sh"; exit 0; fi
    e=${choice##* }
    case $(pick "$e…" "󰐊  Ver prévia" "󰔡  Ligar/desligar") in
        *prévia)   preview "$e" ;;
        *desligar) if grep -qx "$e" "$conf"; then sed -i "s/^$e\$/# $e/" "$conf"
                   else sed -i -E "s/^#[[:space:]]*$e\$/$e/" "$conf"; fi ;;
    esac
done
