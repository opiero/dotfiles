#!/usr/bin/env bash
# Avisa (via mako/notify-send) quando a bateria fica baixa. Cada limite avisa uma
# vez por descarga; ao ligar o carregador, zera e volta a avisar na próxima.
# Iniciado no autostart do hyprland.lua.
set -uo pipefail

bat=/sys/class/power_supply/BAT1
intervalo=60

# Uma instância só (reload do Hyprland não duplica)
exec 9>"${XDG_RUNTIME_DIR:-/tmp}/battery-watch.lock"
flock -n 9 || exit 0

avisado=101   # menor limite já avisado nesta descarga
id=0          # id da notificação, pra substituir a anterior em vez de empilhar

while true; do
    cap=$(<"$bat/capacity") 2>/dev/null || { sleep "$intervalo"; continue; }
    status=$(<"$bat/status") 2>/dev/null || status=Unknown

    if [[ $status != Discharging ]]; then
        avisado=101
    else
        nivel=""
        if   (( cap <= 5  && avisado > 5  )); then nivel=5;  urg=critical; tempo=0
        elif (( cap <= 10 && avisado > 10 )); then nivel=10; urg=critical; tempo=0
        elif (( cap <= 20 && avisado > 20 )); then nivel=20; urg=normal;   tempo=10000
        fi
        if [[ -n $nivel ]]; then
            avisado=$nivel
            id=$(notify-send -p -r "$id" -u "$urg" -t "$tempo" -a bateria \
                -i battery-caution "Bateria baixa: ${cap}%" \
                "Ligue o carregador." 2>/dev/null) || id=0
        fi
    fi
    sleep "$intervalo"
done
