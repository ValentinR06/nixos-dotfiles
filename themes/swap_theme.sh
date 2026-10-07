#!/usr/bin/env bash

THEME_BASE_DIR="$HOME/nixos-dotfiles/themes"
STATE_DIR="$HOME/.cache/theme"

# Define the exact files that exist in EVERY theme folder
# Relative to the theme's root directory
TARGET_FILES=(
  "hypr/colors.lua"
  "quickshell/Colors.qml"
  "kitty/colors.conf"
)

# 1. Get available theme names
get_themes() {
  find "$THEME_BASE_DIR" -maxdepth 1 -mindepth 1 -type d -exec basename {} \;
}

# 2. Swap symlinks for the chosen theme
apply_theme() {
  local theme=$1
  local theme_path="$THEME_BASE_DIR/$theme"

  if [ ! -d "$theme_path" ]; then
    echo "Error: Theme '$theme' does not exist."
    exit 1
  fi

  echo "Activating theme: $theme"

  # Save the active theme to the cache directory
  mkdir -p "$STATE_DIR"
  echo "$theme" >"$STATE_DIR/currentTheme.txt"

  # Loop through our known strict file list
  for relative_path in "${TARGET_FILES[@]}"; do
    local src_file="$theme_path/$relative_path"
    local target_link="$STATE_DIR/$relative_path"

    # Verify the theme actually has the file before linking
    if [ -f "$src_file" ]; then
      # Ensure target state directory exists
      mkdir -p "$(dirname "$target_link")"

      # Atomically replace the symlink
      ln -sf "$src_file" "$target_link"
      echo "Linked: $target_link"
    else
      echo "Warning: Expected file missing in theme: $relative_path"
    fi
  done

  # --- Hyprpaper Logic ---
  local wall_dir="$theme_path/wallpapers"
  local state_file="$theme_path/lastWallpaper.txt"
  local selected_wall=""

  # Check if the theme has a wallpapers folder
  if [ -d "$wall_dir" ]; then
    # Read the last wallpaper if the state file exists and the file it points to is valid
    if [ -f "$state_file" ] && [ -f "$(cat "$state_file")" ]; then
      selected_wall=$(cat "$state_file")
    else
      # Fallback: grab the first file in the directory
      selected_wall=$(find "$wall_dir" -type f | head -n 1)
      echo "$selected_wall" >"$state_file"
    fi

    if [ -n "$selected_wall" ]; then
      echo "Applying wallpaper: $selected_wall"

      # Live apply via IPC
      hyprctl hyprpaper preload "$selected_wall"
      hyprctl hyprpaper wallpaper ",$selected_wall"

      # Unload all other wallpapers from memory
      hyprctl hyprpaper unload all

      # Persist the config to the cache directory so it survives reboot
      cat <<EOF >"$STATE_DIR/hyprpaper.conf"
splash = false
wallpaper {
  monitor = 
  path = $selected_wall
  fit_mode = cover
}
EOF
    fi
  else
    echo "Warning: No 'wallpapers' directory found in $theme_path"
  fi

  # 3. Reload the system components
  reload_environment
}

# 3. Handle live reloading
reload_environment() {
  # --- Hyprland Borders & Window Settings ---
  hyprctl reload

  # --- Kitty Terminal ---
  if pgrep kitty >/dev/null; then
    killall -SIGUSR1 kitty
  fi

  # --- Quickshell Refresh ---
  if pgrep quickshell >/dev/null; then
    # Send a sighup or force restart depending on your quickshell setup
    pkill quickshell && quickshell &
    disown
  fi
}

# --- Main Logic ---
if [ -z "$1" ]; then
  echo "Usage: $0 <theme-name>"
  echo "Available themes:"
  get_themes
else
  apply_theme "$1"
fi