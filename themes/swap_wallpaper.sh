#!/usr/bin/env bash

THEME_BASE_DIR="$HOME/nixos-dotfiles/themes"
STATE_DIR="$HOME/.cache/theme"
CURRENT_THEME_FILE="$STATE_DIR/currentTheme.txt"

# 1. Verify we know what the current theme is
if [ ! -f "$CURRENT_THEME_FILE" ]; then
  echo "Error: currentTheme.txt not found. Run the theme switcher first."
  exit 1
fi

CURRENT_THEME=$(cat "$CURRENT_THEME_FILE")
THEME_DIR="$THEME_BASE_DIR/$CURRENT_THEME"
WALL_DIR="$THEME_DIR/wallpapers"
STATE_FILE="$THEME_DIR/lastWallpaper.txt"

if [ ! -d "$WALL_DIR" ]; then
  echo "Error: No wallpapers directory found for theme $CURRENT_THEME"
  exit 1
fi

# Load all wallpapers into an array and sort them alphabetically
mapfile -t WALLPAPERS < <(find "$WALL_DIR" -type f | sort)
WALL_COUNT=${#WALLPAPERS[@]}

if [ "$WALL_COUNT" -eq 0 ]; then
  echo "Error: No wallpapers found in $WALL_DIR"
  exit 1
fi

SELECTED_WALL=""

# 2. Require an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <number 1-$WALL_COUNT | filename>"
  echo "Available wallpapers in $CURRENT_THEME:"
  for i in "${!WALLPAPERS[@]}"; do
    echo "  $((i + 1)): $(basename "${WALLPAPERS[$i]}")"
  done
  exit 1
fi

INPUT=$1

# 3. Determine which wallpaper to pick
if [[ "$INPUT" =~ ^[0-9]+$ ]]; then
  # Input is a number
  INDEX=$((INPUT - 1)) # Arrays are 0-indexed
  if [ "$INDEX" -ge 0 ] && [ "$INDEX" -lt "$WALL_COUNT" ]; then
    SELECTED_WALL="${WALLPAPERS[$INDEX]}"
  else
    echo "Error: Number must be between 1 and $WALL_COUNT."
    exit 1
  fi
else
  # Input is a string (filename)
  if [ -f "$WALL_DIR/$INPUT" ]; then
    SELECTED_WALL="$WALL_DIR/$INPUT"
  else
    echo "Error: File '$INPUT' not found in $WALL_DIR."
    echo "Available files:"
    for w in "${WALLPAPERS[@]}"; do
      echo "  $(basename "$w")"
    done
    exit 1
  fi
fi

echo "Switching to: $SELECTED_WALL"

# 4. Save the state so the Theme Switcher remembers it next time
echo "$SELECTED_WALL" >"$STATE_FILE"

# 5. Apply live with hyprctl
hyprctl hyprpaper wallpaper ",$SELECTED_WALL"

# 6. Save to hyprpaper.conf in the cache directory so it survives a reboot
cat <<EOF >"$STATE_DIR/hyprpaper.conf"
splash = false
wallpaper {
    monitor = 
    path = $SELECTED_WALL
    fit_mode = cover
}
EOF