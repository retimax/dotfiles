#!/bin/bash

# Ruta a tu archivo de estado (puedes cambiarla)
STATE_FILE="/tmp/polybar_gaps_hidden"

if [ -f "$STATE_FILE" ]; then
    # Polybar visible, gaps normales
    polybar-msg cmd show
    i3-msg "gaps top all set 37"
    i3-msg "gaps inner all set 5"
    rm "$STATE_FILE"
else
    # Polybar oculta, sin gaps
    polybar-msg cmd hide
    i3-msg "gaps top all set 0"
    i3-msg "gaps inner all set 5"
    touch "$STATE_FILE"
fi
