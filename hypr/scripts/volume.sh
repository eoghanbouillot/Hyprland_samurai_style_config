#!/usr/bin/env bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#  VOLUME.SH — Contrôle audio + Notification OSD
#  Style Sumi-e : notification sobre, N&B
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

STEP=3   # % de changement par appui

notify_volume() {
    local vol
    local muted
    vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%.0f", $2 * 100}')
    muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -c MUTED)

    if [ "$muted" -gt 0 ]; then
        icon="󰖁"
        label="沈黙 — Muet"
        bar="▓░░░░░░░░░░░░░░░░░░░"
    else
        icon="󰕾"
        label="音量 — ${vol}%"
        # Barre de progression ASCII (20 blocs)
        filled=$(( vol / 5 ))
        empty=$(( 20 - filled ))
        bar=$(printf '▓%.0s' $(seq 1 $filled))$(printf '░%.0s' $(seq 1 $empty))
    fi

    dunstify \
        --appname="Sumi-e OSD" \
        --urgency=low \
        --timeout=1500 \
        --replace=9999 \
        --icon="" \
        --hints=string:x-dunst-stack-tag:volume \
        "<span font='IPAMincho 13'>${icon}  ${label}</span>\n<span font='Victor Mono 9'>${bar}</span>"
}

case "$1" in
    up)
        wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ ${STEP}%+
        notify_volume
        ;;
    down)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ ${STEP}%-
        notify_volume
        ;;
    mute)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        notify_volume
        ;;
esac
