#!/usr/bin/env bash
# Abre o screensaver em tela cheia em cada monitor (chamado pelo hypridle ou pelo menu).
hyprctl clients -j | jq -e 'any(.[]; .class=="screensaver")' >/dev/null && exit 0

focused=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
for m in $(hyprctl monitors -j | jq -r '.[].name'); do
    hyprctl dispatch "hl.dsp.focus({ monitor = \"$m\" })" >/dev/null
    setsid -f kitty --class screensaver --start-as fullscreen \
        -o background=#000000 -o background_opacity=1 -o window_padding_width=0 \
        -o confirm_os_window_close=0 -o cursor_shape=block \
        -e ~/.config/hypr/screensaver/screensaver.sh >/dev/null 2>&1
    sleep 0.4
done
hyprctl dispatch "hl.dsp.focus({ monitor = \"$focused\" })" >/dev/null
