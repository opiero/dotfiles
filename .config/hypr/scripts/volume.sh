#!/usr/bin/env bash
# Ajusta o volume com wpctl e mostra uma barra (notificação do mako, app-name=osd).
# Uso: volume.sh up|down|mute|mic-mute — chamado pelas teclas multimídia no hyprland.lua.
set -euo pipefail

sink=@DEFAULT_AUDIO_SINK@
source=@DEFAULT_AUDIO_SOURCE@

# O OSD do sink é mostrado pelo volume-watch.sh (cobre também os botões do headphone
# bluetooth); aqui só muda o volume. O do microfone continua sendo mostrado aqui.
case "${1:-}" in
    up)       wpctl set-volume -l 1 "$sink" 5%+; exit 0 ;;
    down)     wpctl set-volume "$sink" 5%-; exit 0 ;;
    mute)     wpctl set-mute "$sink" toggle; exit 0 ;;
    osd)      dev=$sink ;;
    mic-mute) dev=$source; wpctl set-mute "$dev" toggle ;;
    *) echo "uso: $0 up|down|mute|mic-mute|osd" >&2; exit 1 ;;
esac

# "Volume: 0.45" ou "Volume: 0.45 [MUTED]"
out=$(wpctl get-volume "$dev")
vol=$(awk '{ printf "%d", $2 * 100 + 0.5 }' <<<"$out")
muted=false; [[ $out == *MUTED* ]] && muted=true

if [[ $dev == "$source" ]]; then
    if $muted; then icon=$'\U000f036d'; label="Microfone mudo"; else icon=$'\U000f036c'; label="Microfone ${vol}%"; fi
else
    if $muted; then icon=$'\U000f075f'; label="Mudo"
    elif (( vol < 34 )); then icon=$'\U000f057f'; label="Volume ${vol}%"
    elif (( vol < 67 )); then icon=$'\U000f0580'; label="Volume ${vol}%"
    else icon=$'\U000f057e'; label="Volume ${vol}%"
    fi
fi

# Reaproveita a notificação anterior em vez de empilhar uma nova a cada toque
id_file="${XDG_RUNTIME_DIR:-/tmp}/volume-osd.id"
id=$(cat "$id_file" 2>/dev/null || echo 0)
notify-send -a osd -e -t 1500 -h "int:value:$vol" -p -r "$id" "$icon  $label" >"$id_file"
