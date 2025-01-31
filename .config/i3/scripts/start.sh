#!/bin/bash

if xrandr | grep 'HDMI-1-0 connected' ; then
  xrandr --output HDMI-1-0 --mode 1920x1080 --primary --rate 75 --left-of eDP-1

  # Polybar
  killall -q polybar

  # Wait until the processes have been shut down
  while pgrep -x polybar >/dev/null; do sleep 1; done

  screens=$(xrandr --listactivemonitors | grep -v "Monitors" | cut -d" " -f6)

  if [[ $(xrandr --listactivemonitors | grep -v "Monitors" | cut -d" " -f4 | cut -d"+" -f2- | uniq | wc -l) == 1 ]]; then
    MONITOR=$(polybar --list-monitors | cut -d":" -f1) TRAY_POS=right polybar mybar -c $HOME/.config/polybar/bars.ini &
  else
    primary=$(xrandr --query | grep primary | cut -d" " -f1)

    for m in $screens; do
      if [[ $primary == $m ]]; then
        MONITOR=$m TRAY_POS=right polybar mybar -c $HOME/.config/polybar/bars.ini &
      else
        MONITOR=$m TRAY_POS=none polybar mybar -c $HOME/.config/polybar/bars.ini &
    fi
  done
  fi
  # Wallpaper
  feh --bg-fill $HOME/Pictures/wallpapers/main.png

  # Keyboard layout
  setxkbmap latam

  # Effects
  picom
else
  # Polybar
  killall -q polybar

  # Wait until the processes have been shut down
  while pgrep -x polybar >/dev/null; do sleep 1; done

  screens=$(xrandr --listactivemonitors | grep -v "Monitors" | cut -d" " -f6)

  if [[ $(xrandr --listactivemonitors | grep -v "Monitors" | cut -d" " -f4 | cut -d"+" -f2- | uniq | wc -l) == 1 ]]; then
    MONITOR=$(polybar --list-monitors | cut -d":" -f1) TRAY_POS=right polybar mybar -c $HOME/.config/polybar/bars.ini &
  else
    primary=$(xrandr --query | grep primary | cut -d" " -f1)

    for m in $screens; do
      if [[ $primary == $m ]]; then
        MONITOR=$m TRAY_POS=right polybar mybar -c $HOME/.config/polybar/bars.ini &
      else
        MONITOR=$m TRAY_POS=none polybar mybar -c $HOME/.config/polybar/bars.ini &
    fi
  done
  fi
  # Wallpaper
  feh --bg-fill $HOME/Pictures/wallpapers/main.png

  # Keyboard layout
  setxkbmap latam

  # Effects
  picom

fi
