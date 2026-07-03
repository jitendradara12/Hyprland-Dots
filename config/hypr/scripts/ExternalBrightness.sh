#!/usr/bin/env bash
# ==================================================
#  KoolDots (2026)
#  Project URL: https://github.com/LinuxBeginnings
#  License: GNU GPLv3
#  SPDX-License-Identifier: GPL-3.0-or-later
# ==================================================
# External monitor brightness via ddcutil

set -u

step=10
min=5
vcp_code=10  # MCCS VCP feature 0x10: Luminance (brightness)
state_file="/tmp/external_brightness_bus"
cache_file="/tmp/external_brightness_displays.cache"
cache_ttl=300 # 5 minutes

# Detect active Hyprland config mode (Lua entrypoint vs legacy .conf includes)
config_home="${XDG_CONFIG_HOME:-${XDG_CONFIG_HOME:-$HOME/.config}}"
hypr_dir="$config_home/hypr"
lua_entry="$hypr_dir/hyprland.lua"
legacy_lua_entry="$config_home/hyprland.lua"

if [[ -n "${HYPR_CONFIG_MODE:-}" ]]; then
    case "${HYPR_CONFIG_MODE,,}" in
        lua) hypr_config_mode="lua" ;;
        conf|hyprlang) hypr_config_mode="conf" ;;
        auto) hypr_config_mode="" ;;
        *) hypr_config_mode="" ;;
    esac
fi

if [[ -z "${hypr_config_mode:-}" ]]; then
    if [[ -f "$lua_entry" || -f "$legacy_lua_entry" ]]; then
        hypr_config_mode="lua"
    else
        hypr_config_mode="conf"
    fi
fi

# Get list of displays: bus model index
# Format: BUS|MODEL|INDEX
get_displays() {
    if [[ -f "$cache_file" ]]; then
        local now mtime
        now=$(date +%s)
        mtime=$(stat -c %Y "$cache_file")
        if (( now - mtime < cache_ttl )); then
            cat "$cache_file"
            return
        fi
    fi

    local res
    res=$(ddcutil detect --terse 2>/dev/null | awk '
        /^Display/ { 
            if (bus) {
                count[model]++
                print bus "|" model "|" count[model]
            }
            bus=""; model="Unknown"
        }
        /I2C bus:/ { bus=$0; sub(/.*\/dev\/i2c-/, "", bus) }
        /Model:/ { model=$0; sub(/.*Model:[[:space:]]*/, "", model) }
        END { 
            if (bus) {
                count[model]++
                print bus "|" model "|" count[model]
            }
        }
    ')
    
    if [[ -n "$res" ]]; then
        echo "$res" > "$cache_file"
        echo "$res"
    fi
}

get_active_bus() {
    local displays
    displays=$(get_displays)
    if [[ -z "$displays" ]]; then
        return 1
    fi
    
    local saved
    if [[ -f "$state_file" ]]; then
        saved=$(cat "$state_file")
        # Check if saved bus still exists in current displays
        if echo "$displays" | grep -q "^$saved|"; then
            echo "$saved"
            return 0
        fi
    fi
    
    # Default to first display's bus
    echo "$displays" | head -n 1 | cut -d'|' -f1
}

set_active_bus() {
    echo "$1" > "$state_file"
}

cycle_display() {
    local displays
    displays=$(get_displays)
    [[ -z "$displays" ]] && return 1
    
    local current
    current=$(get_active_bus) || return 1
    
    local next
    next=$(echo "$displays" | awk -v current="$current" -F'|' '
        {
            a[n++] = $1
        }
        END {
            for (i=0; i<n; i++) {
                if (a[i] == current) {
                    print a[(i+1)%n]
                    exit
                }
            }
            print a[0]
        }
    ')
    set_active_bus "$next"
}

ddcutil_cmd() {
  local display_arg=()
  local display="${DDCUTIL_DISPLAY:-}"
  if [[ -n "${display}" ]]; then
    display_arg+=(--display "${display}")
  fi
  ddcutil ${DDCUTIL_OPTS:-} "${display_arg[@]}" "$@"
}

get_brightness() {
  # Example output: "VCP code 0x10 (Brightness): current value = 50, max value = 100"
  local line
  if ! line="$(ddcutil_cmd getvcp "${vcp_code}" 2>/dev/null | tail -n 1)"; then
    return 1
  fi
  local current max
  current="$(printf "%s" "${line}" | sed -n 's/.*current value = \([0-9]\+\).*/\1/p')"
  max="$(printf "%s" "${line}" | sed -n 's/.*max value = \([0-9]\+\).*/\1/p')"
  [[ -n "${current}" && -n "${max}" ]] || return 1
  printf "%s %s\n" "${current}" "${max}"
}

set_brightness() {
  local value="$1"
  ddcutil_cmd setvcp "${vcp_code}" "${value}" >/dev/null 2>&1
}

json_output() {
  local current max percent icon
  if ! read -r current max < <(get_brightness); then
    printf '{"text":"󰃜 N/A","tooltip":"External brightness unavailable (load i2c-dev, allow i2c access)","class":"brightness-external-off"}\n'
    return 0
  fi
  percent=$(( current * 100 / max ))
  if (( percent >= 80 )); then
    icon="󰃠"
  elif (( percent >= 60 )); then
    icon="󰃟"
  elif (( percent >= 40 )); then
    icon="󰃞"
  elif (( percent >= 20 )); then
    icon="󰃝"
  else
    icon=""
  fi
  printf '{"text":"%s %s%%","tooltip":"External display brightness: %s%%","class":"brightness-external"}\n' "${icon}" "${percent}" "${percent}"
}

case "${1:-}" in
  --get|"")
    json_output
    ;;
  --inc|--dec)
    read -r current max < <(get_brightness) || exit 1
    delta=$step
    [[ "$1" == "--dec" ]] && delta=$(( -step ))
    new=$(( current + delta ))
    (( new < 5 )) && new=5
    (( new > max )) && new="${max}"
    set_brightness "${new}"
    json_output
    ;;
  --set)
    [[ -n "${2:-}" ]] || { usage; exit 1; }
    set_brightness "${2}"
    json_output
    ;;
  --display)
    [[ -n "${2:-}" ]] || { usage; exit 1; }
    DDCUTIL_DISPLAY="${2}" shift 2
    "${0}" "${@:-"--get"}"
    ;;
  -h|--help)
    usage
    ;;
  *)
    usage
    exit 1
    ;;
esac
