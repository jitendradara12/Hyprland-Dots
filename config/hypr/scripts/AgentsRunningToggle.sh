#!/usr/bin/env bash
PIDFILE="/tmp/agents_running.pid"
BRIFILE="/tmp/agents_running.bri"

restore() {
    [ -f "$PIDFILE" ] && kill "$(cat "$PIDFILE")" 2>/dev/null
    rm -f "$PIDFILE"
    hyprctl dispatch dpms on >/dev/null 2>&1
    [ -f "$BRIFILE" ] && brightnessctl set "$(cat "$BRIFILE")" >/dev/null 2>&1 && rm -f "$BRIFILE"
    notify-send "Agents Mode" "OFF: Screen restored & sleep enabled" 2>/dev/null
}

if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
    restore
else
    brightnessctl g > "$BRIFILE" 2>/dev/null
    brightnessctl set 0 >/dev/null 2>&1
    hyprctl dispatch dpms off >/dev/null 2>&1
    systemd-inhibit --what=handle-lid-switch:sleep:idle --why="Agents running" sleep infinity &
    echo $! > "$PIDFILE"
    notify-send "Agents Mode" "ON: Screen off & sleep inhibited" 2>/dev/null
fi
