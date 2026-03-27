#!/bin/bash
# ~/.config/xmonad/scripts/detect-monitors.sh
# Script robusto para detección automática de monitores en XMonad

# Configuración
LAPTOP_DISPLAY="eDP-1"
EXTERNAL_DISPLAY="HDMI-1-0"
WALLPAPER="$HOME/Pictures/wallpapers/gustavedore.png"
LOG_FILE="$HOME/.local/share/xmonad/monitor-detect.log"

# Crear directorio de logs si no existe
mkdir -p "$(dirname "$LOG_FILE")"

# Función de logging
log_msg() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log_msg "=== Iniciando detección de monitores ==="

# Esperar un momento para que xrandr se estabilice
sleep 1

# Detectar estado de monitores
EXTERNAL_CONNECTED=$(xrandr | grep "$EXTERNAL_DISPLAY connected" | wc -l)
LAPTOP_ACTIVE=$(xrandr | grep "$LAPTOP_DISPLAY connected" | wc -l)

log_msg "Monitor externo detectado: $EXTERNAL_CONNECTED"
log_msg "Pantalla laptop activa: $LAPTOP_ACTIVE"

# Configurar según estado de conexión
if [ "$EXTERNAL_CONNECTED" -eq 1 ]; then
    log_msg "Configurando modo dual monitor..."
    
    # Primero activar ambas pantallas
    xrandr --output "$LAPTOP_DISPLAY" --auto \
           --output "$EXTERNAL_DISPLAY" --auto
    
    # Luego configurar la disposición
    xrandr --output "$EXTERNAL_DISPLAY" \
           --mode 1920x1080 \
           --rate 75 \
           --primary \
           --left-of "$LAPTOP_DISPLAY" \
           --output "$LAPTOP_DISPLAY" --auto
    
    log_msg "Modo dual monitor configurado"
    
elif [ "$LAPTOP_ACTIVE" -eq 1 ]; then
    log_msg "Configurando modo laptop solo..."
    
    # Desactivar monitor externo y activar laptop como principal
    xrandr --output "$EXTERNAL_DISPLAY" --off \
           --output "$LAPTOP_DISPLAY" --primary --auto
    
    log_msg "Modo laptop solo configurado"
else
    log_msg "ERROR: No se detectó ninguna pantalla activa"
    exit 1
fi

# Esperar a que xrandr termine de configurar
sleep 1

# Recargar fondo de pantalla
if [ -f "$WALLPAPER" ]; then
    feh --bg-fill "$WALLPAPER" 2>/dev/null
    log_msg "Fondo de pantalla recargado"
else
    log_msg "WARN: No se encontró el wallpaper en $WALLPAPER"
fi

# NO matar xmobar - dejar que XMonad lo maneje
# XMonad detectará el cambio y ajustará las barras automáticamente
log_msg "Notificando a XMonad sobre el cambio de configuración"

# Notificar al usuario (requiere dunst o notify-send)
if command -v notify-send &> /dev/null; then
    if [ "$EXTERNAL_CONNECTED" -eq 1 ]; then
        notify-send -u low "Monitor Detectado" "Configuración dual monitor aplicada"
    else
        notify-send -u low "Monitor Desconectado" "Usando solo pantalla del laptop"
    fi
fi

log_msg "=== Detección completada exitosamente ==="
exit 0
