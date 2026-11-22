#!/usr/bin/env bash
# Escolhe quais animações (savers/) o screensaver sorteia. Menu do walker; Esc sai.
set -uo pipefail
dir=~/.config/hypr/screensaver
conf=$dir/savers.conf
touch "$conf"

pick() { local p=$1; shift; printf '%s\n' "$@" | walker --dmenu --placeholder "$p" 2>/dev/null; }
is_on() { grep -qx "$1" "$conf"; }

preview() {
    kitty --class floating-default -o background=#000000 -o background_opacity=1 \
        -o confirm_os_window_close=0 -e timeout 15 "$dir/savers/$1" >/dev/null 2>&1
}

while true; do
    lines=() on=0
    for f in "$dir"/savers/*; do
        [[ -x $f ]] || continue; s=${f##*/}
        if is_on "$s"; then lines+=("󰄲  $s"); ((on++)); else lines+=("󰄱  $s"); fi
    done
    choice=$(pick "Ligadas: $on (nenhuma = todas) — escolha uma" "󰐊  Testar o screensaver" "${lines[@]}") || exit 0
    [[ -z $choice ]] && exit 0
    if [[ $choice == *Testar* ]]; then setsid -f "$dir/launch.sh"; exit 0; fi
    s=${choice##* }
    case $(pick "$s…" "󰐊  Ver prévia (15s)" "󰔡  Ligar/desligar") in
        *prévia*)  preview "$s" ;;
        *desligar) if is_on "$s"; then sed -i "s/^$s\$/# $s/" "$conf"
                   elif grep -qE "^#[[:space:]]*$s\$" "$conf"; then sed -i -E "s/^#[[:space:]]*$s\$/$s/" "$conf"
                   else echo "$s" >> "$conf"; fi ;;
    esac
done
