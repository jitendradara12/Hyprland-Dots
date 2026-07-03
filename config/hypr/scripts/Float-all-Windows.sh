#!/usr/bin/env bash
# ==================================================
#  KoolDots (2026)
#  Project URL: https://github.com/LinuxBeginnings
#  License: GNU GPLv3
#  SPDX-License-Identifier: GPL-3.0-or-later
# ==================================================

# Detect active Hyprland config mode (Lua entrypoint vs legacy .conf includes)
config_home="${XDG_CONFIG_HOME:-${XDG_CONFIG_HOME:-$HOME/.config}}"
hypr_dir="$config_home/hypr"
lua_entry="$hypr_dir/hyprland.lua"
legacy_lua_entry="$config_home/hyprland.lua"

if [[ -f "$lua_entry" || -f "$legacy_lua_entry" ]]; then
    hypr_config_mode="lua"
else
    hypr_config_mode="conf"
fi

# Get current workspace ID
ws=$(hyprctl activeworkspace -j | jq -r .id)
hyprctl clients -j | jq -r --arg ws "$ws" '.[] | select(.workspace.id == ($ws|tonumber)) | .address' | xargs -r -I {} hyprctl dispatch togglefloating address:{}
