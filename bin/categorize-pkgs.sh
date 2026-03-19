#!/usr/bin/env bash

mkdir -p ~/pkglists/categories

input_file="$HOME/pkglists/pacman-packages.txt"

declare -A categories=(
  [dev]="nodejs|go|gcc|rust|python|yarn|git|docker|cmake|make"
  [media]="vlc|mpv|ffmpeg|audacity|obs"
  [browser]="firefox|chromium|brave|vivaldi"
  [design]="gimp|krita|inkscape"
  [util]="htop|btop|timeshift|tlp|neovim"
  [productivity]="libreoffice|notion|obsidian"
)

for category in "${!categories[@]}"; do
  grep -Ei "${categories[$category]}" "$input_file" > "$HOME/pkglists/categories/$category.txt"
done

# Leftovers (uncategorized)
grep -vFf <(cat ~/pkglists/categories/*.txt) "$input_file" > "$HOME/pkglists/categories/uncategorized.txt"
