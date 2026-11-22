#!/usr/bin/env bash
# Screensaver DENTRO da tela de bloqueio. O hyprlock esconde todas as janelas, então a
# animação vira texto: um saver roda com --pango e escreve cada quadro em $frame, que um
# label do hyprlock (o último do hyprlock.conf, por cima de tudo) relê a cada 125 ms.
# Sem o arquivo, o label fica vazio e a tela de bloqueio normal aparece.
# Uso: lock-screensaver.sh start|stop   (chamado pelo hypridle)
dir=~/.config/hypr/screensaver
run=${XDG_RUNTIME_DIR:-/tmp}
frame=$run/hypr-screensaver.pango
pidf=$run/hypr-screensaver.pid
FONT="JetBrainsMono Nerd Font 12"   # tem que bater com font_family/font_size do label

running() { [[ -f $pidf ]] && kill -0 "$(<"$pidf")" 2>/dev/null; }

start() {
    running && return 0
    # Savers ligados em savers.conf que sabem desenhar para o bloqueio (--pango); senão, todos que sabem.
    mapfile -t savers < <(grep -vE '^[[:space:]]*(#|$)' "$dir/savers.conf" 2>/dev/null)
    ok=(); for s in "${savers[@]}"; do grep -q -- '--pango' "$dir/savers/$s" 2>/dev/null && ok+=("$s"); done
    (( ${#ok[@]} )) || for f in "$dir"/savers/*; do grep -q -- '--pango' "$f" && ok+=("${f##*/}"); done
    (( ${#ok[@]} )) || exit 0
    s=${ok[RANDOM % ${#ok[@]}]}

    # Grade que cobre o maior monitor (tamanho lógico), medindo a célula no Pango como o hyprlock.
    read -r w h < <(hyprctl monitors -j | jq -r 'map({w: (.width / .scale), h: (.height / .scale)}) | "\(map(.w) | max | ceil) \(map(.h) | max | ceil)"')
    read -r cw ch < <(python3 - "$FONT" <<'PY'
import sys, gi
gi.require_version("Pango", "1.0"); gi.require_version("PangoCairo", "1.0")
from gi.repository import Pango, PangoCairo
import cairo
lay = PangoCairo.create_layout(cairo.Context(cairo.ImageSurface(cairo.FORMAT_ARGB32, 1, 1)))
lay.set_font_description(Pango.FontDescription(sys.argv[1]))
lay.set_markup('<span background="#000000">' + ("─" * 20 + "\n") * 19 + "─" * 20 + "</span>", -1)
w, h = lay.get_pixel_size(); print(w / 20, h / 20)
PY
)
    cols=$(python3 -c "import math;print(math.ceil($w/$cw)+4)")
    rows=$(python3 -c "import math;print(math.ceil($h/$ch)+2)")
    aspect=$(python3 -c "print($ch/$cw)")
    setsid -f "$dir/savers/$s" --pango "$frame" --cols "$cols" --rows "$rows" --aspect "$aspect" --fps 8 \
        >/dev/null 2>&1 </dev/null
    sleep 0.2; pgrep -nf -- "--pango $frame" > "$pidf"
}

stop() {
    running && kill "$(<"$pidf")" 2>/dev/null
    rm -f "$pidf" "$frame" "$frame.tmp"
}

case ${1:-} in
    start) start ;;
    stop)  stop ;;
    *) echo "uso: $0 start|stop" >&2; exit 2 ;;
esac
