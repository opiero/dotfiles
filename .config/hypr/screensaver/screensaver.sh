#!/usr/bin/env bash
# Roda DENTRO da janela do kitty: sorteia uma animação de savers/ (entre as ligadas em
# savers.conf) e troca a cada $ROTATE segundos. Sai com qualquer tecla, movimento ou
# clique do mouse, ou se o foco sair do screensaver.
dir=~/.config/hypr/screensaver
conf=$dir/savers.conf
ROTATE=${SCREENSAVER_ROTATE:-120}

cleanup() {
    [[ -n ${pid:-} ]] && kill "$pid" 2>/dev/null
    printf '\e[0m\e[?1003l\e[?1000l\e[?25h'
    # fecha as janelas de todos os monitores (pela classe, não pela linha de comando)
    hyprctl clients -j | jq -r '.[] | select(.class=="screensaver") | .pid' | xargs -r kill 2>/dev/null
    exit 0
}
trap cleanup INT TERM HUP QUIT

in_focus() { [[ $(hyprctl activewindow -j 2>/dev/null | jq -r .class) == screensaver ]]; }

# Ligados = linhas sem # em savers.conf que existam em savers/; se nenhuma, usa todas.
enabled() {
    local s found=()
    while read -r s; do [[ -x $dir/savers/$s ]] && found+=("$s"); done \
        < <(grep -vE '^[[:space:]]*(#|$)' "$conf" 2>/dev/null)
    (( ${#found[@]} )) || for s in "$dir"/savers/*; do [[ -x $s ]] && found+=("${s##*/}"); done
    printf '%s\n' "${found[@]}"
}

# Esconde o cursor e liga o "any-motion mouse tracking": o kitty passa a mandar
# o movimento do mouse como bytes no stdin, então o `read` abaixo pega isso também.
printf '\e[?25l\e[?1000h\e[?1003h'
start=$SECONDS last=

while true; do
    mapfile -t savers < <(enabled)
    (( ${#savers[@]} )) || cleanup
    s=${savers[RANDOM % ${#savers[@]}]}
    # não repete a mesma em seguida (se houver outra)
    (( ${#savers[@]} > 1 )) && while [[ $s == "$last" ]]; do s=${savers[RANDOM % ${#savers[@]}]}; done
    last=$s
    clear
    "$dir/savers/$s" &   # em background o stdin vira /dev/null: só o `read` daqui lê o teclado
    pid=$!
    until_=$(( ${#savers[@]} > 1 ? SECONDS + ROTATE : 1 << 62 ))
    while kill -0 "$pid" 2>/dev/null && (( SECONDS < until_ )); do
        read -rsn1 -t 1 && cleanup
        # carência de 3s: no lançamento, as janelas dos outros monitores ainda estão abrindo
        (( SECONDS - start > 3 )) && ! in_focus && cleanup
    done
    kill "$pid" 2>/dev/null; wait "$pid" 2>/dev/null
done
