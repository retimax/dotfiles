#!/usr/bin/env bash

STATE_FILE="/tmp/polybar_gaps_hidden_zero"

if [ -f "$STATE_FILE" ]; then
  polybar-msg cmd show
  i3-msg "gaps top all set 37"
  i3-msg "gaps inner all set 5"
  i3-msg "gaps bottom all set 2"
  notify-send "UI MODE CHANGED" "Normal Mode"
  rm "$STATE_FILE"
else
  polybar-msg cmd hide
  i3-msg "gaps top all set 0"
  i3-msg "gaps inner all set 0"
  i3-msg "gaps bottom all set 0"
  notify-send "UI MODE CHANGED" "No polybar no gaps"
  touch "$STATE_FILE"
fi
