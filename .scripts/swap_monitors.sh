#!/bin/bash

# Obter o monitor atual
current_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.activeWorkspace.id == '"$(hyprctl activeworkspace -j | jq '.id')"') | .name')

# Obter o nome do monitor alternativo
other_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.name != "'"$current_monitor"'") | .name')

# Mover o workspace atual para o outro monitor
hyprctl dispatch movecurrentworkspace "$other_monitor"
