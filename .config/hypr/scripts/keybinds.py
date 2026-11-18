#!/usr/bin/env python3
"""Lista os keybinds ativos do Hyprland (hyprctl binds -j) num formato legível.

Usado pelo atalho SUPER+SHIFT+/ (keybinds.sh abre isso no fzf). Binds sem
descrição aparecem com o nome do dispatcher; pra ficarem legíveis, coloque
`description = "..."` no hl.bind do hyprland.lua.
"""
import json
import re
import subprocess

MODS = [(64, "SUPER"), (4, "CTRL"), (8, "ALT"), (1, "SHIFT")]
KEY_NAMES = {
    "RETURN": "Enter", "BACKSPACE": "Backspace", "SPACE": "Space",
    "PRINT": "Print", "SLASH": "/", "mouse_down": "Scroll ↓", "mouse_up": "Scroll ↑",
    "mouse:272": "Botão esquerdo", "mouse:273": "Botão direito",
}


def combo(modmask, key):
    parts = [name for bit, name in MODS if modmask & bit]
    key = KEY_NAMES.get(key) or KEY_NAMES.get(key.upper()) or key
    if len(key) == 1:
        key = key.upper()
    return " + ".join(parts + [key])


def describe(b):
    if b["description"]:
        return b["description"]
    m = re.match(r"HL\.Dispatcher\((\w+)\)", b["dispatcher"])
    return f"({m.group(1) if m else b['dispatcher']})"


binds = json.loads(subprocess.check_output(["hyprctl", "binds", "-j"]))
rows, seen_ranges = [], set()
for b in binds:
    desc = describe(b)
    # Junta os 10 binds de workspace (1..0) numa linha só
    if re.fullmatch(r"\d", b["key"]) and re.search(r"workspace \d+", desc):
        generic = re.sub(r"workspace \d+", "workspace N", desc)
        k = (b["modmask"], generic)
        if k in seen_ranges:
            continue
        seen_ranges.add(k)
        rows.append((combo(b["modmask"], "[1-0]"), generic))
        continue
    rows.append((combo(b["modmask"], b["key"]), desc))

width = max(len(c) for c, _ in rows)
for c, d in rows:
    print(f"{c.ljust(width)}   {d}")
