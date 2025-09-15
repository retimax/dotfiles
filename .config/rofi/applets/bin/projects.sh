#!/usr/bin/env bash

## Author   : Karol Rivas (r0lk444)
## Github   : @RETIMAX

# Import current theme
source "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$type/$style"
prompt="Projects Menu"
terminal="/usr/bin/kitty"

# Projects info
projects_dir="$HOME/Desktop/projects"

# List projects
list_projects() {
  if [ -d "$projects_dir" ]; then
    find "$projects_dir" -maxdepth 1 -type d ! -path "$projects_dir" -exec basename {} \;
  else
    echo "[!] El directorio $projects_dir no existe"
  fi
}

rofi_cmd() {
  if [ ! -d "$projects_dir" ]; then
    rofi -e "ERROR: directory not found: $projects_dir"
    exit 1
  fi

  projects=$(list_projects)
  
  if [ -z "$projects" ] || [[ "$projects" == *"[!]"* ]]; then
    rofi -e "No projects found in $projects_dir or directory doesn't exist"
    exit 1
  fi

  selected=$(echo "$projects" | rofi -dmenu -p "$prompt" -theme "$theme")

  # Path of the selected project
  if [ -n "$selected" ] && [[ "$selected" != "[!]"* ]]; then
    project_path="$projects_dir/$selected"

    # Verify if this directory exist
    if [ ! -d "$project_path" ]; then
      rofi -e "Error: Project '$selected' doesn't exist"
      exit 1
    fi

    # Change current directoy before launching rofi
    cd "$project_path" || exit 1

    # Open with terminal
    if command -v kitty >/dev/null 2>&1; then
      exec $terminal nvim . &
    else
      rofi -e "Cannot open the project: Kitty not found"
      exit 1
    fi
  fi
}

rofi_cmd
