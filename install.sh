#!/bin/bash

# =============================================================================
# Arch Linux Developer Workstation Bootstrap Script
# =============================================================================
# Run this script after a fresh Arch install to set up the full environment.
# Usage: ./install.sh
# =============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# =============================================================================
# Helper Functions
# =============================================================================

log()     { echo -e "${GREEN}[✓]${NC} $1"; }
info()    { echo -e "${BLUE}[→]${NC} $1"; }
warn()    { echo -e "${YELLOW}[!]${NC} $1"; }
error()   { echo -e "${RED}[✗]${NC} $1"; }
section() { echo -e "\n${CYAN}══════════════════════════════════════${NC}"; echo -e "${CYAN}  $1${NC}"; echo -e "${CYAN}══════════════════════════════════════${NC}"; }

# Check if a command exists
has() { command -v "$1" &>/dev/null; }

# Check if a pacman package is installed
installed() { pacman -Qi "$1" &>/dev/null; }

# Install pacman packages only if not already installed
pacman_install() {
    local to_install=()
    for pkg in "$@"; do
        if ! installed "$pkg"; then
            to_install+=("$pkg")
        else
            warn "Already installed: $pkg — skipping"
        fi
    done
    if [ ${#to_install[@]} -gt 0 ]; then
        info "Installing: ${to_install[*]}"
        sudo pacman -S --noconfirm --needed "${to_install[@]}"
    fi
}

# Install AUR packages only if not already installed
aur_install() {
    local to_install=()
    for pkg in "$@"; do
        if ! installed "$pkg"; then
            to_install+=("$pkg")
        else
            warn "Already installed (AUR): $pkg — skipping"
        fi
    done
    if [ ${#to_install[@]} -gt 0 ]; then
        info "Installing from AUR: ${to_install[*]}"
        yay -S --noconfirm --needed "${to_install[@]}"
    fi
}

# Enable a systemd service only if not already active
enable_service() {
    if ! systemctl is-enabled "$1" &>/dev/null; then
        info "Enabling service: $1"
        sudo systemctl enable --now "$1"
    else
        warn "Service already enabled: $1 — skipping"
    fi
}

# Enable a user systemd service only if not already active
enable_user_service() {
    if ! systemctl --user is-enabled "$1" &>/dev/null; then
        info "Enabling user service: $1"
        systemctl --user enable --now "$1"
    else
        warn "User service already enabled: $1 — skipping"
    fi
}

# Create a symlink only if it doesn't already point to the right place
symlink() {
    local src="$1"
    local dst="$2"
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        warn "Symlink already exists: $dst — skipping"
    else
        if [ -e "$dst" ] && [ ! -L "$dst" ]; then
            warn "Backing up existing $dst to $dst.bak"
            mv "$dst" "$dst.bak"
        fi
        info "Creating symlink: $dst → $src"
        ln -sf "$src" "$dst"
    fi
}

# =============================================================================
# Pre-flight checks
# =============================================================================

section "Pre-flight Checks"

# Must not be root
if [ "$EUID" -eq 0 ]; then
    error "Do not run this script as root. Run as your normal user."
    exit 1
fi

# Must be on Arch Linux
if ! has pacman; then
    error "This script is for Arch Linux only."
    exit 1
fi

# Get dotfiles directory (script location)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
log "Dotfiles directory: $DOTFILES_DIR"

# Confirm before proceeding
echo ""
echo -e "${YELLOW}This script will set up your Arch Linux developer workstation.${NC}"
echo -e "${YELLOW}It will install packages, create symlinks, and configure services.${NC}"
echo ""
read -rp "Continue? [y/N] " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

# =============================================================================
# 1. System Update
# =============================================================================

section "1. System Update"

info "Updating system..."
sudo pacman -Syu --noconfirm
log "System updated"

# =============================================================================
# 2. Essential System Packages
# =============================================================================

section "2. Essential System Packages"

pacman_install \
    base-devel \
    git \
    curl \
    wget \
    unzip \
    zip \
    tar \
    man-db \
    man-pages \
    reflector \
    pacman-contrib \
    xclip \
    xdotool \
    playerctl \
    btop \
    tree \
    openssh

log "Essential packages done"

# =============================================================================
# 3. Network
# =============================================================================

section "3. Network"

pacman_install networkmanager nm-connection-editor network-manager-applet
enable_service NetworkManager
log "Network done"

# =============================================================================
# 4. AUR Helper — yay
# =============================================================================

section "4. AUR Helper — yay"

if has yay; then
    warn "yay already installed — skipping"
else
    info "Installing yay..."
    cd /tmp
    rm -rf yay
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd "$DOTFILES_DIR"
    log "yay installed"
fi

# =============================================================================
# 5. Fonts
# =============================================================================

section "5. Fonts"

pacman_install \
    ttf-jetbrains-mono-nerd \
    ttf-firacode-nerd \
    noto-fonts \
    noto-fonts-emoji \
    ttf-font-awesome

info "Refreshing font cache..."
fc-cache -fv &>/dev/null
log "Fonts done"

# =============================================================================
# 6. Display Server & i3
# =============================================================================

section "6. Display Server & i3"

pacman_install \
    xorg \
    xorg-xinit \
    xorg-server \
    xorg-xrandr \
    xorg-xsetroot \
    feh \
    picom

# i3 components — check individually since archinstall may have installed some
pacman_install i3-wm i3status i3lock i3blocks dmenu dex xss-lock xautolock

# Set up .xinitrc only if it doesn't already exec i3
if [ ! -f "$HOME/.xinitrc" ] || ! grep -q "exec i3" "$HOME/.xinitrc"; then
    info "Creating ~/.xinitrc"
    echo "exec i3" > "$HOME/.xinitrc"
    log ".xinitrc created"
else
    warn "~/.xinitrc already has exec i3 — skipping"
fi

# Set up auto-start X on login in .bash_profile
if [ ! -f "$HOME/.bash_profile" ] || ! grep -q "startx" "$HOME/.bash_profile"; then
    info "Adding startx to ~/.bash_profile"
    cat >> "$HOME/.bash_profile" << 'EOF'

# Auto-start X on login
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = "1" ]; then
  exec startx
fi
EOF
    log ".bash_profile updated"
else
    warn "startx already in ~/.bash_profile — skipping"
fi

log "Display server & i3 done"

# =============================================================================
# 7. Audio — PipeWire
# =============================================================================

section "7. Audio — PipeWire"

pacman_install pipewire pipewire-pulse pipewire-audio wireplumber pamixer

enable_user_service pipewire
enable_user_service pipewire-pulse
enable_user_service wireplumber

# Auto-switch audio to bluetooth on connect
PIPEWIRE_CONF_DIR="/etc/pipewire/pipewire-pulse.conf.d"
if [ ! -f "$PIPEWIRE_CONF_DIR/switch-on-connect.conf" ]; then
    info "Setting up bluetooth auto-switch..."
    sudo mkdir -p "$PIPEWIRE_CONF_DIR"
    sudo tee "$PIPEWIRE_CONF_DIR/switch-on-connect.conf" > /dev/null << 'EOF'
pulse.cmd = [
    { cmd = "load-module" args = "module-switch-on-connect" flags = [] }
]
EOF
    log "Bluetooth auto-switch configured"
else
    warn "Bluetooth auto-switch already configured — skipping"
fi

log "Audio done"

# =============================================================================
# 8. Bluetooth
# =============================================================================

section "8. Bluetooth"

pacman_install bluez bluez-utils blueman
enable_service bluetooth

# Auto-enable bluetooth adapter on boot
BT_CONF="/etc/bluetooth/main.conf"
if grep -q "^#AutoEnable=true" "$BT_CONF" 2>/dev/null; then
    info "Enabling bluetooth AutoEnable..."
    sudo sed -i 's/#AutoEnable=true/AutoEnable=true/' "$BT_CONF"
    log "Bluetooth AutoEnable set"
elif grep -q "^AutoEnable=true" "$BT_CONF" 2>/dev/null; then
    warn "Bluetooth AutoEnable already set — skipping"
else
    warn "Could not find AutoEnable in $BT_CONF — set it manually"
fi

log "Bluetooth done"

# =============================================================================
# 9. Volume & Brightness
# =============================================================================

section "9. Volume & Brightness"

pacman_install brightnessctl libnotify

# Brightness notify script
BRIGHTNESS_SCRIPT="$HOME/.local/bin/brightness-notify"
if [ ! -f "$BRIGHTNESS_SCRIPT" ]; then
    info "Creating brightness-notify script..."
    mkdir -p "$HOME/.local/bin"
    cat > "$BRIGHTNESS_SCRIPT" << 'EOF'
#!/bin/bash
MAX=$(brightnessctl max)
CUR=$(brightnessctl get)
PCT=$(( CUR * 100 / MAX ))
notify-send -t 800 "Brightness" "${PCT}%"
EOF
    chmod +x "$BRIGHTNESS_SCRIPT"
    log "brightness-notify script created"
else
    warn "brightness-notify script already exists — skipping"
fi

# Add ~/.local/bin to PATH if not already there
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
    info "Adding ~/.local/bin to PATH in ~/.bashrc"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
fi

log "Volume & brightness done"

# =============================================================================
# 10. Notifications — Dunst
# =============================================================================

section "10. Notifications — Dunst"

pacman_install dunst libcanberra sox

# Notification sound scripts
SOUND_DIR="$HOME/.local/bin"
mkdir -p "$SOUND_DIR"

if [ ! -f "$SOUND_DIR/dunst-notify-sound-low" ]; then
    info "Creating dunst sound scripts..."
    cat > "$SOUND_DIR/dunst-notify-sound-low" << 'EOF'
#!/bin/bash
play -qn synth 0.08 sine 600 vol 0.2 2>/dev/null &
EOF
    cat > "$SOUND_DIR/dunst-notify-sound-normal" << 'EOF'
#!/bin/bash
play -qn synth 0.1 sine 880 vol 0.3 2>/dev/null &
EOF
    cat > "$SOUND_DIR/dunst-notify-sound-critical" << 'EOF'
#!/bin/bash
play -qn synth 0.1 sine 880 : synth 0.1 sine 1100 vol 0.5 2>/dev/null &
EOF
    chmod +x "$SOUND_DIR"/dunst-notify-sound-*
    log "Dunst sound scripts created"
else
    warn "Dunst sound scripts already exist — skipping"
fi

log "Dunst done"

# =============================================================================
# 11. Alacritty
# =============================================================================

section "11. Alacritty"

pacman_install alacritty ueberzugpp
log "Alacritty done"

# =============================================================================
# 12. Tmux
# =============================================================================

section "12. Tmux"

pacman_install tmux

# Install TPM only if not already installed
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
    info "Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    log "TPM installed"
else
    warn "TPM already installed — skipping"
fi

log "Tmux done"

# =============================================================================
# 13. Neovim
# =============================================================================

section "13. Neovim"

pacman_install \
    neovim \
    nodejs \
    npm \
    python \
    python-pip \
    cargo \
    make \
    gcc

log "Neovim done"

# =============================================================================
# 14. CLI Tools
# =============================================================================

section "14. CLI Tools"

pacman_install \
    ripgrep \
    fd \
    fzf \
    bat \
    eza \
    zoxide \
    lazygit \
    zsh

log "CLI tools done"

# =============================================================================
# 15. File Manager & Image Editing
# =============================================================================

section "15. File Manager & Image Editing"

pacman_install yazi gimp

# Yazi image preview config
YAZI_CONFIG="$HOME/.config/yazi/yazi.toml"
if [ ! -f "$YAZI_CONFIG" ]; then
    info "Creating yazi image preview config..."
    mkdir -p "$HOME/.config/yazi"
    cat > "$YAZI_CONFIG" << 'EOF'
[preview]
image_protocol = "ueberzug"
EOF
    log "Yazi config created"
else
    warn "Yazi config already exists — skipping"
fi

log "File manager & image editing done"

# =============================================================================
# 16. AUR Packages
# =============================================================================

section "16. AUR Packages"

aur_install zen-browser discord
log "AUR packages done"

# =============================================================================
# 17. Dotfiles Symlinks
# =============================================================================

section "17. Dotfiles Symlinks"

mkdir -p "$HOME/.config"

# i3
[ -d "$DOTFILES_DIR/i3" ] && symlink "$DOTFILES_DIR/i3" "$HOME/.config/i3" || warn "i3 config not found in dotfiles"

# i3blocks
[ -d "$DOTFILES_DIR/i3blocks" ] && symlink "$DOTFILES_DIR/i3blocks" "$HOME/.config/i3blocks" || warn "i3blocks config not found in dotfiles"

# Alacritty
[ -d "$DOTFILES_DIR/alacritty" ] && symlink "$DOTFILES_DIR/alacritty" "$HOME/.config/alacritty" || warn "alacritty config not found in dotfiles"

# Neovim
[ -d "$DOTFILES_DIR/nvim" ] && symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim" || warn "nvim config not found in dotfiles"

# Yazi (only if dotfiles has it, otherwise we keep the one we created above)
if [ -d "$DOTFILES_DIR/yazi" ]; then
    symlink "$DOTFILES_DIR/yazi" "$HOME/.config/yazi"
fi

# Dunst
[ -d "$DOTFILES_DIR/dunst" ] && symlink "$DOTFILES_DIR/dunst" "$HOME/.config/dunst" || warn "dunst config not found in dotfiles"

# Tmux
[ -f "$DOTFILES_DIR/.tmux.conf" ] && symlink "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf" || warn ".tmux.conf not found in dotfiles"
[ -d "$DOTFILES_DIR/.tmux" ] && symlink "$DOTFILES_DIR/.tmux" "$HOME/.tmux" || warn ".tmux dir not found in dotfiles"

log "Symlinks done"

# =============================================================================
# 18. Install Tmux Plugins
# =============================================================================

section "18. Tmux Plugins"

if [ -f "$HOME/.tmux.conf" ] && [ -d "$HOME/.tmux/plugins/tpm" ]; then
    info "Installing tmux plugins via TPM..."
    "$HOME/.tmux/plugins/tpm/bin/install_plugins" &>/dev/null && log "Tmux plugins installed" || warn "TPM install had issues — run 'Tab + I' inside tmux manually"
else
    warn "Tmux config or TPM not found — skipping plugin install"
fi

# =============================================================================
# 19. Neovim Plugin Install
# =============================================================================

section "19. Neovim Plugins"

if has nvim && [ -f "$HOME/.config/nvim/init.lua" ]; then
    info "Installing Neovim plugins via lazy.nvim (headless)..."
    nvim --headless "+Lazy! sync" +qa 2>/dev/null && log "Neovim plugins installed" || warn "Neovim plugin install had issues — open nvim and run :Lazy sync manually"
else
    warn "Neovim config not found — open nvim manually to install plugins"
fi

# =============================================================================
# 20. Shell Setup
# =============================================================================

section "20. Shell"

# Set zsh as default shell if not already
if [ "$SHELL" != "$(which zsh)" ]; then
    info "Setting zsh as default shell..."
    chsh -s "$(which zsh)"
    log "Default shell set to zsh (takes effect on next login)"
else
    warn "zsh already default shell — skipping"
fi

# =============================================================================
# 21. Permissions
# =============================================================================

section "21. Permissions"

# Add user to video group for brightness control
if ! groups "$USER" | grep -q video; then
    info "Adding $USER to video group for brightness control..."
    sudo usermod -aG video "$USER"
    log "Added to video group (takes effect on next login)"
else
    warn "Already in video group — skipping"
fi

# =============================================================================
# Done
# =============================================================================

section "Setup Complete"

echo ""
echo -e "${GREEN}Everything is set up! A few things to do manually:${NC}"
echo ""
echo -e "  ${YELLOW}1.${NC} Reboot or log out/in for group changes and shell change to take effect"
echo -e "  ${YELLOW}2.${NC} Set your wallpaper: ${CYAN}feh --bg-scale /path/to/wallpaper.jpg${NC}"
echo -e "  ${YELLOW}3.${NC} Pair your Bluetooth devices: ${CYAN}bluetoothctl${NC}"
echo -e "  ${YELLOW}4.${NC} Set Anthropic API key if using avante.nvim:"
echo -e "     ${CYAN}echo 'export ANTHROPIC_API_KEY=\"sk-ant-...\"' >> ~/.bashrc${NC}"
echo -e "  ${YELLOW}5.${NC} Inside tmux, press ${CYAN}Tab + I${NC} to confirm plugins installed"
echo -e "  ${YELLOW}6.${NC} Open nvim and run ${CYAN}:Mason${NC} to verify LSP servers"
echo ""
echo -e "${GREEN}Done! Welcome to your new machine.${NC}"
echo ""
