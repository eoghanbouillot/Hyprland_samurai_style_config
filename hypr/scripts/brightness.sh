#!/usr/bin/env bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#  BRIGHTNESS.SH — Luminosité + Notification OSD
#  Utilise brightnessctl (apt/pacman install brightnessctl)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

STEP=5

notify_brightness() {
    local bright
    bright=$(brightnessctl -m | awk -F',' '{print $4}' | tr -d '%')
    filled=$(( bright / 5 ))
    empty=$(( 20 - filled ))
    bar=$(printf '▓%.0s' $(seq 1 $filled))$(printf '░%.0s' $(seq 1 $empty))

    dunstify \
        --appname="Sumi-e OSD" \
        --urgency=low \
        --timeout=1500 \
        --replace=9998 \
        --hints=string:x-dunst-stack-tag:brightness \
        "<span font='IPAMincho 13'>󰖙  光 — ${bright}%</span>\n<span font='Victor Mono 9'>${bar}</span>"
}

case "$1" in
    up)
        brightnessctl set ${STEP}%+
        notify_brightness
        ;;
    down)
        brightnessctl set ${STEP}%-
        notify_brightness
        ;;
esac
