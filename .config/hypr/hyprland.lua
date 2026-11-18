-- Migrado de hyprland.conf + bindings.conf + autostart.conf (formato hyprlang, descontinuado desde o Hyprland 0.55).
-- Ver https://wiki.hypr.land/Configuring/Start/

------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "eDP-1",
    mode     = "2880x1800@120.00",
    position = "-5248x640",
    scale    = 2.00,
})

hl.monitor({
    output   = "HDMI-A-1",
    mode     = "3840x2160@30.00",
    position = "-3776x448",
    scale    = 2.00,
})


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "kitty"
local fileManager = "dolphin"
local browser     = "firefox"
local menu        = "hyprlauncher"
local mainMod     = "SUPER"


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprsunset")
    hl.exec_cmd("clipse -listen")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Valores padrão (usados também pelo toggle de gaps, SUPER+SHIFT+BACKSPACE)
local default_gaps_in, default_gaps_out, default_border = 5, 5, 2

hl.config({
    general = {
        gaps_in  = default_gaps_in,
        gaps_out = default_gaps_out,

        border_size = default_border,

        col = {
            active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = false,
        allow_tearing    = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })

hl.config({
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = false,
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "intl",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0.3,

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


---------------------
---- KEYBINDINGS ----
---------------------

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal), { description = "abre o terminal" })
hl.bind(mainMod .. " + W", hl.dsp.window.close(), { description = "fecha a janela" })
hl.bind("SUPER + SHIFT + O", hl.dsp.exec_cmd("obsidian"), { description = "abre o obsidian" })
hl.bind("SUPER + SHIFT + I", hl.dsp.exec_cmd(browser), { description = "abre o navegador" })
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen(), { description = "deixa a janela em tela cheia" })
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"), { description = "sai do Hyprland" })
hl.bind(mainMod .. " + O", hl.dsp.workspace.move({ monitor = "+1" }), { description = "move o workspace para o monitor seguinte" })
hl.bind("SUPER + SHIFT + X", hl.dsp.exec_cmd("hyprlock"), { description = "bloqueia a tela" })
hl.bind("SUPER + CONTROL + V", hl.dsp.exec_cmd(terminal .. " --class floating-default -e 'clipse'"), { description = "abre o clipboard manager" })
hl.bind("SUPER + SHIFT + D", hl.dsp.exec_cmd(terminal .. " --class floating-default -e 'lazydocker'"), { description = "abre o lazydocker" })
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd(terminal .. " --class floating-default -e 'bluetui'"), { description = "abre o bluetooth" })
hl.bind("PRINT", hl.dsp.exec_cmd("/home/pieroc/.local/bin/hyprshot -m window"), { description = "bate o print da janela" })
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("/home/pieroc/.local/bin/hyprshot -m region"), { description = "bate o print da região" })

hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager), { description = "abre o gerenciador de arquivos" })
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }), { description = "alterna a janela entre flutuante e tiled" })
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu), { description = "abre o launcher" })
-- Troca os workspaces ativos entre o monitor em foco e o próximo
-- (com 2 monitores: o workspace do A vai pro B e o do B vai pro A)
hl.bind(mainMod .. " + P", function()
    local mons = hl.get_monitors()
    if #mons < 2 then return end
    for i, mon in ipairs(mons) do
        if mon.focused then
            local other = mons[i % #mons + 1]
            hl.dispatch(hl.dsp.workspace.swap_monitors({ monitor1 = mon.name, monitor2 = other.name }))
            return
        end
    end
end, { description = "troca os workspaces ativos entre os monitores" })

hl.bind(mainMod .. " + T", hl.dsp.layout("togglesplit"), { description = "alterna o split (horizontal/vertical)" })

-- Toggle de gaps (estilo Omarchy): zera os gaps (mantém a borda), ou volta pros padrões
hl.bind("SUPER + SHIFT + BACKSPACE", function()
    local on = hl.get_config("general:gaps_out").top == 0
    hl.config({ general = {
        gaps_in     = on and default_gaps_in  or 0,
        gaps_out    = on and default_gaps_out or 0,
    } })
end, { description = "liga/desliga os gaps entre janelas" })

-- Mostra todos os keybinds num fzf (estilo Omarchy)
hl.bind("SUPER + SHIFT + SLASH", hl.dsp.exec_cmd(terminal .. " --class floating-default -e ~/.config/hypr/scripts/keybinds.sh"), { description = "mostra todos os keybinds" })

-- Move focus com mainMod + HJKL (vim-style)
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }), { description = "foca a janela à esquerda" })
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }), { description = "foca a janela à direita" })
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }), { description = "foca a janela de cima" })
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }), { description = "foca a janela de baixo" })

-- Move a janela com mainMod + SHIFT + HJKL (vim-style)
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }),  { description = "move a janela pra esquerda" })
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }), { description = "move a janela pra direita" })
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }),    { description = "move a janela pra cima" })
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }),  { description = "move a janela pra baixo" })

-- Troca de workspace com mainMod + [0-9]
-- Move janela ativa para um workspace com mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }), { description = "vai pro workspace " .. i })
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }), { description = "move a janela pro workspace " .. i })
end

-- Workspace especial (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"), { description = "mostra/esconde o scratchpad" })
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }), { description = "move a janela pro scratchpad" })

-- Scroll entre workspaces com mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "próximo workspace" })
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }), { description = "workspace anterior" })

-- Mover/redimensionar janelas com mainMod + botão do mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true, description = "arrasta a janela" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "redimensiona a janela" })

-- Teclas multimídia
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh up"), { locked = true, repeating = true, description = "aumenta o volume" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh down"),      { locked = true, repeating = true, description = "diminui o volume" })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh mute"),     { locked = true, repeating = true, description = "muta o som" })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("~/.config/hypr/scripts/volume.sh mic-mute"),   { locked = true, repeating = true, description = "muta o microfone" })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true, description = "aumenta o brilho" })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true, description = "diminui o brilho" })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true, description = "próxima música" })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "pausa a música" })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true, description = "toca a música" })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true, description = "música anterior" })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
    name  = "floating-default-float",
    match = { class = "floating-default" },
    float = true,
})

hl.window_rule({
    name  = "floating-default-size",
    match = { class = "floating-default" },
    size  = "1000 652",
})

hl.window_rule({
    -- Ignora pedidos de maximizar de todos os apps.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    -- Corrige problemas de arraste no XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

hl.window_rule({
    name  = "pritunl-floating",
    match = { class = "(?i)^pritunl$" },

    float  = true,
    size   = "430 520",
    center = true,
})

hl.window_rule({
    name  = "pip-floating",
    match = { title = "^(Picture-in-Picture)$" },

    float = true,
})

hl.window_rule({
    -- Overlay transparente do Untapped por cima do MTG Arena: sem blur/sombra/borda,
    -- senão o Arena inteiro fica embaçado atrás dele.
    name  = "untapped-overlay",
    match = { class = "^steam_proton$", title = "^Untapped\\.gg Overlay$" },

    float       = true,
    no_blur     = true,
    no_shadow   = true,
    border_size = 0,
    no_anim     = true,
})

hl.window_rule({
    -- Bandeja do Wine (explorer.exe /desktop) no prefixo do Arena: o Waybar não mostra
    -- ícones de bandeja do Wine, então ele cria uma barrinha flutuante. Esconde num
    -- workspace especial (abrir: hyprctl dispatch 'hl.dsp.workspace.toggle_special("wine-tray")').
    name  = "wine-tray-arena",
    match = { class = "^steam_app_2141910$", title = "^$", float = true },

    workspace = "special:wine-tray silent",
})
