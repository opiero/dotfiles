#!/usr/bin/env bash
# Mostra o OSD de volume sempre que o volume/mudo do sink padrão muda, venha de onde vier:
# teclas multimídia, botões do headphone bluetooth (AVRCP absolute volume, que não gera
# tecla nenhuma pro Hyprland), pavucontrol etc. Iniciado no autostart do hyprland.lua.
set -uo pipefail

osd=~/.config/hypr/scripts/volume.sh

# Uma instância só (reload do Hyprland não duplica)
exec 9>"${XDG_RUNTIME_DIR:-/tmp}/volume-watch.lock"
flock -n 9 || exit 0

state() { printf '%s|%s' "$(pactl get-default-sink 2>/dev/null)" "$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)"; }

last=$(state)
while true; do
    # pactl subscribe morre se o pipewire-pulse reiniciar; o laço externo reconecta
    while read -r line; do
        [[ $line == *"'change' on sink #"* || $line == *"'change' on server"* ]] || continue
        cur=$(state)
        [[ $cur == "$last" ]] && continue
        # Troca de sink padrão (ex.: conectou o headphone) só atualiza a base, sem OSD
        if [[ ${cur%%|*} == "${last%%|*}" ]]; then
            "$osd" osd
        fi
        last=$cur
    done < <(pactl subscribe 2>/dev/null)
    sleep 1
    last=$(state)
done
