#!/usr/bin/env bash
# Menu de sistema (SUPER+ALT+SPACE), estilo Omarchy, em cima do `walker --dmenu`.
# Uso: menu.sh [sistema|captura|alternar|ferramentas|configs]  (sem argumento: menu principal)
# Pra adicionar um item: coloque a linha no `pick` do submenu e o caso correspondente no `case`.
set -uo pipefail

scripts=~/.config/hypr/scripts
hyprshot=/home/pieroc/.local/bin/hyprshot
float="kitty --class floating-default -e"

# pick "placeholder" "opção 1" "opção 2" ... -> imprime a opção escolhida (vazio se Esc)
pick() {
    local placeholder=$1; shift
    printf '%s\n' "$@" | walker --dmenu --placeholder "$placeholder" 2>/dev/null
}

# Roda desacoplado do script (via Hyprland), pra não morrer quando o menu fecha
run() { hyprctl dispatch "hl.dsp.exec_cmd(\"$*\")" >/dev/null 2>&1 || setsid -f sh -c "$*"; }

confirm() { [[ $(pick "$1" "󰄬  Sim" "󰜺  Não") == *Sim ]]; }

menu_main() {
    case $(pick "Menu…" "󰀻  Apps" "󰐥  Sistema" "󰄀  Captura" "󰔡  Alternar" "󰒓  Ferramentas" "󰈙  Configs") in
        *Apps)        run walker ;;
        *Sistema)     menu_sistema ;;
        *Captura)     menu_captura ;;
        *Alternar)    menu_alternar ;;
        *Ferramentas) menu_ferramentas ;;
        *Configs)     menu_configs ;;
    esac
}

menu_sistema() {
    case $(pick "Sistema…" "󰌾  Bloquear" "󱄄  Screensaver" "󰸉  Efeitos do screensaver" "󰤄  Suspender" "󰗽  Sair do Hyprland" "󰜉  Reiniciar" "󰐥  Desligar") in
        *Bloquear)  run hyprlock ;;
        *Efeitos*)    ~/.config/hypr/screensaver/effects.sh ;;
        *Screensaver) run ~/.config/hypr/screensaver/launch.sh ;;
        *Suspender) run "hyprlock & sleep 1 && systemctl suspend" ;;
        *Sair*)     confirm "Sair do Hyprland?" && run "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit" ;;
        *Reiniciar) confirm "Reiniciar?" && systemctl reboot ;;
        *Desligar)  confirm "Desligar?" && systemctl poweroff ;;
    esac
}

menu_captura() {
    local choice
    choice=$(pick "Captura…" "󰩭  Região" "󰖯  Janela" "󰍹  Tela inteira")
    sleep 0.3  # deixa o walker sumir antes de capturar
    case $choice in
        *Região)       run "$hyprshot -m region" ;;
        *Janela)       run "$hyprshot -m window" ;;
        *Tela*)        run "$hyprshot -m output" ;;
    esac
}

menu_alternar() {
    case $(pick "Alternar…" "󰕰  Gaps" "󰖔  Luz noturna" "󰍜  Waybar" "󰂛  Não perturbe") in
        *Gaps) hyprctl eval 'toggle_gaps()' >/dev/null ;;
        *Luz*)
            if [[ $(hyprctl hyprsunset temperature) -ge 6000 ]]; then
                hyprctl hyprsunset temperature 4500 >/dev/null
            else
                hyprctl hyprsunset identity >/dev/null
            fi ;;
        *Waybar) pkill -x waybar || run waybar ;;
        *perturbe)
            makoctl mode -t do-not-disturb >/dev/null
            makoctl mode | grep -qx do-not-disturb || notify-send -a Sistema "Não perturbe desligado" ;;
    esac
}

menu_ferramentas() {
    case $(pick "Ferramentas…" "󰅌  Clipboard" "󰂯  Bluetooth" "󰡨  Docker" "󰌌  Keybinds") in
        *Clipboard) run "$float clipse" ;;
        *Bluetooth) run "$float bluetui" ;;
        *Docker)    run "$float lazydocker" ;;
        *Keybinds)  run "$float $scripts/keybinds.sh" ;;
    esac
}

menu_configs() {
    local file
    case $(pick "Configs…" "  Hyprland" "󰍜  Waybar" "󰂚  Notificações (mako)" "󰀻  Launcher (walker)") in
        *Hyprland) file=~/.config/hypr/hyprland.lua ;;
        *Waybar)   file="$HOME/.config/waybar/config $HOME/.config/waybar/style.css" ;;
        *mako*)    file=~/.config/mako/config ;;
        *walker*)  file="$HOME/.config/walker/config.toml $HOME/.config/walker/themes/dotfiles/style.css" ;;
        *) return ;;
    esac
    run "kitty -e ${EDITOR:-nvim} $file"
}

case ${1:-} in
    sistema)     menu_sistema ;;
    captura)     menu_captura ;;
    alternar)    menu_alternar ;;
    ferramentas) menu_ferramentas ;;
    configs)     menu_configs ;;
    *)           menu_main ;;
esac
