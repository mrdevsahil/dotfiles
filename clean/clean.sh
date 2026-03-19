#!/bin/bash

echo "🔧 Starting Linux System Cleanup and Organization..."

CLEANED=false

# --- Pacman cache and orphan cleanup ---
echo "🧹 Cleaning pacman cache and orphaned packages..."
if sudo pacman -Qtdq &>/dev/null; then
  echo "Removing orphans..."
  sudo pacman -Rns --noconfirm $(pacman -Qtdq)
  CLEANED=true
else
  echo "No orphan packages to remove."
fi

echo "Clearing pacman cache except for the latest packages..."
sudo pacman -Sc --noconfirm

# --- Yay cache cleanup ---
echo "🧼 Cleaning yay cache..."
yay -Sc --noconfirm

# --- npm cache cleanup ---
echo "🧼 Cleaning npm cache..."
npm cache clean --force
CLEANED=true # npm cache clean usually cleans something, mark true anyway

# --- Docker cleanup ---
echo "🗑 Removing unused Docker resources..."
if docker info &>/dev/null; then
  if sudo docker system prune -af &>/dev/null; then
    CLEANED=true
  else
    echo "Failed to clean Docker resources or none to clean."
  fi
else
  echo "Docker not running or not installed."
fi

# --- Flatpak cleanup ---
if command -v flatpak &>/dev/null; then
  echo "🧼 Cleaning Flatpak system..."
  if flatpak uninstall --unused -y &>/dev/null; then
    CLEANED=true
  else
    echo "No unused Flatpak runtimes or apps to remove."
  fi
fi

# --- Snap cleanup ---
if command -v snap &>/dev/null; then
  echo "🧼 Cleaning Snap cache..."
  snap set system refresh.retain=2
  CLEANED=true
fi

# --- Notify only if something was cleaned ---
if $CLEANED; then
  notify-send -u normal -t 5000 -i system-run "🧹 System Cleanup Completed" "Your system cleanup tasks finished successfully."
  paplay /usr/share/sounds/freedesktop/stereo/complete.oga 2>/dev/null &
  echo "Cleanup done and notification sent."
else
  echo "Nothing to clean, no notification sent."
fi
