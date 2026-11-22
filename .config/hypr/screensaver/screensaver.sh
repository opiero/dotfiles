#!/usr/bin/env bash
# Roda DENTRO da janela do kitty: anima o logo com um efeito aleatório do tte, em loop.
# Sai com qualquer tecla, movimento/clique do mouse ou se o foco sair do screensaver.
logo=~/.config/hypr/screensaver/logo.txt
tte=~/.local/bin/tte
conf=~/.config/hypr/screensaver/effects.conf

cleanup() {
    printf '\e[?1003l\e[?1000l\e[?25h'
    pkill -P $$ -x tte 2>/dev/null
    # fecha as janelas de todos os monitores (pela classe, não pela linha de comando)
    hyprctl clients -j | jq -r '.[] | select(.class=="screensaver") | .pid' | xargs -r kill 2>/dev/null
    exit 0
}
trap cleanup INT TERM HUP QUIT

in_focus() { [[ $(hyprctl activewindow -j 2>/dev/null | jq -r .class) == screensaver ]]; }

# Esconde o cursor e liga o "any-motion mouse tracking": o kitty passa a mandar
# o movimento do mouse como bytes no stdin, então o `read` abaixo pega isso também.
printf '\e[?25l\e[?1000h\e[?1003h'
start=$SECONDS

while true; do
    clear
    # Sorteia entre os efeitos ligados em effects.conf (relido a cada volta);
    # se a lista estiver vazia, cai no sorteio de todos do tte.
    mapfile -t effects < <(grep -vE '^[[:space:]]*(#|$)' "$conf" 2>/dev/null)
    if (( ${#effects[@]} )); then
        effect=(${effects[RANDOM % ${#effects[@]}]})
    else
        effect=(--random-effect --exclude-effects dev_worm)
    fi
    "$tte" -i "$logo" --frame-rate 120 \
        --canvas-width 0 --canvas-height 0 --anchor-canvas c --anchor-text c \
        --no-eol --no-restore-cursor "${effect[@]}" &
    pid=$!
    while kill -0 "$pid" 2>/dev/null; do
        read -rsn1 -t 1 && cleanup
        # carência de 3s: no lançamento, as janelas dos outros monitores ainda estão abrindo
        (( SECONDS - start > 3 )) && ! in_focus && cleanup
    done
    read -rsn1 -t 3 && cleanup   # segura o quadro final um pouco antes do próximo efeito
done
