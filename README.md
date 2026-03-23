# 🖥️ Arch Linux Developer Workstation Setup

> A complete, battle-tested guide to setting up Arch Linux with i3, Neovim, Tmux, Alacritty, and a full developer environment from scratch. Every command, every package, every config change — in order.

---

## 📋 Table of Contents

- [1. Bootstrap setup install script](#1-bootstrap-setup-install-script)
- [2. Base Arch Installation](#2-base-arch-installation)
- [3. Essential System Packages](#3-essential-system-packages)
- [4. AUR Helper — yay](#4-aur-helper--yay)
- [5. Fonts](#5-fonts)
- [6. Display Server & i3 Window Manager](#6-display-server--i3-window-manager)
- [7. i3 Configuration](#7-i3-configuration)
- [8. i3 Status Bar — i3blocks](#8-i3-status-bar--i3blocks)
- [9. Alacritty Terminal](#9-alacritty-terminal)
- [10. Tmux](#10-tmux)
- [11. Notifications — Dunst](#11-notifications--dunst)
- [12. Screen Lock](#12-screen-lock)
- [13. Bluetooth](#13-bluetooth)
- [14. Audio — PipeWire](#14-audio--pipewire)
- [15. File Manager — Yazi](#15-file-manager--yazi)
- [16. Neovim](#16-neovim)
- [17. Neovim Plugins & Config](#17-neovim-plugins--config)
- [18. LSP Servers & Formatters](#18-lsp-servers--formatters)
- [19. Shell & CLI Tools](#19-shell--cli-tools)
- [20. Dotfiles Setup with Symlinks](#20-dotfiles-setup-with-symlinks)
- [21. System Maintenance](#21-system-maintenance)
- [22. Keybindings Reference](#22-keybindings-reference)
- [23. Troubleshooting](#23-troubleshooting)
- [24. Full Package List](#24-full-package-list)

---

## 1. Bootstrap setup install script

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

### NOTE: Follow the steps bellow only if the installation script fails to setup.

---

## 2. Base Arch Installation

Follow the official [Arch Installation Guide](https://wiki.archlinux.org/title/Installation_guide) for the base install. After booting into the installed system, update everything:

```bash
sudo pacman -Syu
```

---

## 3. Essential System Packages

```bash
sudo pacman -S \
  base-devel \
  git \
  curl \
  wget \
  unzip \
  zip \
  tar \
  ripgrep \
  fd \
  fzf \
  xclip \
  xdotool \
  playerctl \
  btop \
  tree \
  man-db \
  man-pages \
  reflector \
  networkmanager \
  nm-connection-editor \
  network-manager-applet \
  pacman-contrib

# Enable networking
sudo systemctl enable --now NetworkManager
```

---

## 4. AUR Helper — yay

```bash
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

---

## 5. Fonts

Install before configuring anything visual so everything renders correctly:

```bash
sudo pacman -S \
  ttf-jetbrains-mono-nerd \
  ttf-firacode-nerd \
  noto-fonts \
  noto-fonts-emoji \
  ttf-font-awesome

# Refresh font cache
fc-cache -fv
```

---

## 6. Display Server & i3 Window Manager

### Install X11 and i3

```bash
sudo pacman -S \
  xorg \
  xorg-xinit \
  xorg-server \
  xorg-xrandr \
  xorg-xsetroot \
  i3 \
  i3status \
  i3lock \
  i3blocks \
  dmenu \
  dex \
  xss-lock \
  xautolock \
  feh \
  picom
```

### Auto-start X on login

Add to `~/.bash_profile` or `~/.zprofile`:

```bash
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = "1" ]; then
  exec startx
fi
```

Create `~/.xinitrc`:

```bash
echo "exec i3" > ~/.xinitrc
```

### Set Wallpaper

```bash
feh --bg-scale /path/to/wallpaper.jpg
# feh saves the command to ~/.fehbg which i3 runs on startup
```

---

## 7. i3 Configuration

Location: `~/.config/i3/config`

### Full Config

```ini
set $mod Mod1

font pango:JetBrainsMono Nerd Font 10

exec --no-startup-id dex --autostart --environment i3
exec --no-startup-id xss-lock -- i3lock -c 1e1e2e
exec --no-startup-id nm-applet
exec --no-startup-id ~/.fehbg
exec --no-startup-id xautolock -time 5 -locker 'i3lock -c 1e1e2e'
exec --no-startup-id pkill dunst; dunst
exec --no-startup-id blueman-applet

set $refresh_i3status killall -SIGUSR1 i3status
bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10% && $refresh_i3status
bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10% && $refresh_i3status
bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && $refresh_i3status
bindsym XF86AudioMicMute exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status

floating_modifier $mod
tiling_drag modifier titlebar

# Applications
bindsym $mod+Return exec alacritty
bindsym $mod+f exec firefox
bindsym $mod+z exec zen-browser
bindsym $mod+q kill
bindsym $mod+d exec --no-startup-id dmenu_run

# Focus
bindsym $mod+h focus left
bindsym $mod+l focus right
bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right

# Move windows
bindsym $mod+Shift+j move left
bindsym $mod+Shift+k move down
bindsym $mod+Shift+l move up
bindsym $mod+Shift+semicolon move right
bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right

# Layout
bindsym $mod+shift+f fullscreen toggle
bindsym $mod+s layout stacking
bindsym $mod+w layout tabbed
bindsym $mod+e layout toggle split
bindsym $mod+Shift+space floating toggle
bindsym $mod+space focus mode_toggle
bindsym $mod+a focus parent

# Workspace navigation
bindsym $mod+j workspace prev
bindsym $mod+k workspace next

set $ws1 "1"
set $ws2 "2"
set $ws3 "3"
set $ws4 "4"

bindsym $mod+1 workspace number $ws1
bindsym $mod+2 workspace number $ws2
bindsym $mod+3 workspace number $ws3
bindsym $mod+4 workspace number $ws4

bindsym $mod+Shift+1 move container to workspace number $ws1
bindsym $mod+Shift+2 move container to workspace number $ws2
bindsym $mod+Shift+3 move container to workspace number $ws3
bindsym $mod+Shift+4 move container to workspace number $ws4

# i3 control
bindsym $mod+Shift+c reload
bindsym $mod+Shift+r restart
bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'Exit i3?' -B 'Yes, exit i3' 'i3-msg exit'"

# Lock screen
bindsym $mod+Shift+x exec i3lock -c 1e1e2e

# Status bar
bar {
    position top
    status_command i3blocks -c ~/.config/i3blocks/config
    font pango:JetBrainsMono Nerd Font 10

    colors {
        background #1e1e2e
        statusline #cdd6f4
        separator  #45475a

        focused_workspace   #89b4fa   #89b4fa     #1e1e2e
        active_workspace    #313244   #313244     #cdd6f4
        inactive_workspace  #1e1e2e   #1e1e2e     #6c7086
        urgent_workspace    #f38ba8   #f38ba8     #1e1e2e
        binding_mode        #a6e3a1   #a6e3a1     #1e1e2e
    }
}

# Volume Mode
set $mode_volume  VOL: [j] down  [k] up  [m] mute  [Escape] exit

mode "$mode_volume" {
    bindsym j exec --no-startup-id pamixer -d 5, exec notify-send -t 800 "Volume" "$(pamixer --get-volume)%"
    bindsym k exec --no-startup-id pamixer -i 5, exec notify-send -t 800 "Volume" "$(pamixer --get-volume)%"
    bindsym m exec --no-startup-id pamixer -t, exec notify-send -t 800 "Volume" "Mute toggled"
    bindsym Escape mode "default"
    bindsym Return mode "default"
}

bindsym $mod+v mode "$mode_volume"

# Brightness Mode
set $mode_brightness  BRIGHT: [j] down  [k] up  [Escape] exit

mode "$mode_brightness" {
    bindsym j exec --no-startup-id brightnessctl set 15%- && ~/.local/bin/brightness-notify
    bindsym k exec --no-startup-id brightnessctl set +15% && ~/.local/bin/brightness-notify
    bindsym Escape mode "default"
    bindsym Return mode "default"
}

bindsym $mod+b mode "$mode_brightness"

# Resize Mode
mode "resize" {
    bindsym j resize shrink width 10 px or 10 ppt
    bindsym k resize grow width 10 px or 10 ppt
    bindsym Left resize shrink width 10 px or 10 ppt
    bindsym Right resize grow width 10 px or 10 ppt
    bindsym Up resize shrink height 10 px or 10 ppt
    bindsym Down resize grow height 10 px or 10 ppt
    bindsym Return mode "default"
    bindsym Escape mode "default"
}

bindsym $mod+r mode "resize"

# Theme
client.focused         #2e3440 #2e3440 #eceff4 #81a1c1 #2e3440
client.unfocused       #2e3440 #2e3440 #d8dee9 #4c566a #2e3440
client.background      #1e1e2e
```

### Volume & Brightness Dependencies

```bash
sudo pacman -S pamixer brightnessctl libnotify
```

Brightness notify script:

```bash
mkdir -p ~/.local/bin
cat > ~/.local/bin/brightness-notify << 'EOF'
#!/bin/bash
MAX=$(brightnessctl max)
CUR=$(brightnessctl get)
PCT=$(( CUR * 100 / MAX ))
notify-send -t 800 "Brightness" "${PCT}%"
EOF
chmod +x ~/.local/bin/brightness-notify
```

### i3 Keybindings

| Keybinding            | Action                    |
| --------------------- | ------------------------- |
| `Alt + Return`        | Open Alacritty            |
| `Alt + f`             | Firefox                   |
| `Alt + z`             | Zen Browser               |
| `Alt + d`             | dmenu launcher            |
| `Alt + q`             | Kill window               |
| `Alt + h / l`         | Focus left / right        |
| `Alt + j / k`         | Previous / next workspace |
| `Alt + 1-4`           | Go to workspace           |
| `Alt + Shift + 1-4`   | Move window to workspace  |
| `Alt + Shift + Space` | Toggle floating           |
| `Alt + Shift + f`     | Fullscreen                |
| `Alt + v`             | Volume mode               |
| `Alt + b`             | Brightness mode           |
| `Alt + r`             | Resize mode               |
| `Alt + Shift + x`     | Lock screen               |
| `Alt + Shift + r`     | Restart i3                |
| `Alt + Shift + c`     | Reload i3 config          |

---

## 8. i3 Status Bar — i3blocks

### Install

```bash
sudo pacman -S i3blocks
```

### Config — `~/.config/i3blocks/config`

```ini
[volume]
command=echo "󰕾 $(pamixer --get-volume)%"
interval=2
color=#cdd6f4

[brightness]
command=echo "󰃞 $(( $(cat /sys/class/backlight/intel_backlight/brightness) * 100 / $(cat /sys/class/backlight/intel_backlight/max_brightness) ))%"
interval=2
color=#cdd6f4

[wifi]
command=iwgetid -r | awk '{print "󰖩 " $0}' || echo "󰖪 disconnected"
interval=5
color=#cdd6f4

[memory]
command=free -h | awk '/^Mem:/ {print "󰍛 " $3 "/" $2}'
interval=5
color=#cdd6f4

[cpu]
command=echo "󰻠 $(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf "%d%%", usage}')"
interval=2
color=#cdd6f4

[time]
command=date "+󰃰 %d %b %H:%M"
interval=5
color=#cdd6f4
```

> **Note:** The brightness path `/sys/class/backlight/intel_backlight/` is for Intel GPUs. Check yours with `ls /sys/class/backlight/`.

> **Note:** The `date` format must be `date "+icon %d %b %H:%M"` — the icon must be inside the quotes with the format string, not before them.

---

## 9. Alacritty Terminal

```bash
sudo pacman -S alacritty
```

Config location: `~/.config/alacritty/alacritty.toml`

---

## 10. Tmux

### Install

```bash
sudo pacman -S tmux
```

### Install TPM (Plugin Manager)

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### Config — `~/.tmux.conf`

```bash
# General
set -g history-limit 5000
set -g mouse on
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'egel/tmux-gruvbox'

# Change prefix from Ctrl-b to Tab
unbind C-b
set-option -g prefix Tab
bind Tab send-prefix

# Appearance
set -g status-bg black
set -g status-fg green
set -g status-interval 5

# Reload config
bind r source-file ~/.tmux.conf \; display "tmux reloaded"

# Split panes
bind '/' split-window -h
bind ';' split-window -v

# Vim style pane navigation
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Switch windows
bind -n M-[ previous-window
bind -n M-] next-window

# Kill window
bind-key p confirm-before -p "Kill window? (y/n)" kill-window

# Rename window/session
bind-key i command-prompt -p "Rename window: " "rename-window '%%'"
bind s command-prompt -p "Rename session: " "rename-session '%%'"

# New session
bind-key n command-prompt -p "Enter session name: " "new-session -s '%%'"

# Session switcher with fzf
bind t display-popup -E -x 35 -y 25 "tmux list-sessions | sed -E 's/:.*$//' | grep -v \"^$(tmux display-message -p '#S')\$\" | cat <(tmux display-message -p '#S') - | fzf --reverse | xargs tmux switch-client -t"

# Window switcher with fzf
bind u display-popup -E -x 35 -y 25 "tmux list-windows | fzf --reverse --with-nth=2 --delimiter=':' | awk -F: '{print \$1}' | xargs -I{} tmux select-window -t {}"

# Session persistence
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @continuum-restore 'on'
set -g @continuum-save-interval '15'

# Status bar styling
set-option -g status-left-length 40
set -g status-style "bg=default,fg=white"
set -g status-position bottom
setw -g window-status-format " #I:#W "
setw -g window-status-style "fg=colour244"
setw -g window-status-current-format " #I:#W "
setw -g window-status-current-style "fg=white,bold"
setw -g window-status-separator ""
set -g status-left "#S  "
set -g status-right ""

run '~/.tmux/plugins/tpm/tpm'
```

### Install Plugins

```bash
~/.tmux/plugins/tpm/bin/install_plugins
```

Or inside tmux press `Tab + I`.

### Session Persistence

Sessions auto-save every 15 minutes and restore automatically on `tmux` start.

```bash
Tab + Ctrl+s    # Manual save
Tab + Ctrl+r    # Manual restore
```

### Tmux Keybindings

| Keybinding      | Action                |
| --------------- | --------------------- |
| `Tab + r`       | Reload config         |
| `Tab + /`       | Split vertically      |
| `Tab + ;`       | Split horizontally    |
| `Tab + h/j/k/l` | Navigate panes        |
| `Tab + p`       | Kill window (confirm) |
| `Tab + i`       | Rename window         |
| `Tab + s`       | Rename session        |
| `Tab + n`       | New session           |
| `Tab + t`       | Switch session (fzf)  |
| `Tab + u`       | Switch window (fzf)   |
| `Tab + Ctrl+s`  | Save session          |
| `Tab + Ctrl+r`  | Restore session       |
| `M-[` / `M-]`   | Prev / next window    |

---

## 11. Notifications — Dunst

### Install

```bash
sudo pacman -S dunst libnotify libcanberra sox
```

### Config — `~/.config/dunst/dunstrc`

```ini
[global]
    monitor = 0
    origin = top-right
    offset = (10, 40)
    width = 300
    height = (0, 100)
    gap_size = 6
    padding = 10
    horizontal_padding = 12
    corner_radius = 8
    font = Monospace 10
    markup = full
    format = "<b>%s</b>\n%b"
    word_wrap = yes
    frame_width = 2
    frame_color = "#81a1c1"

[urgency_low]
    background = "#2e3440"
    foreground = "#d8dee9"
    frame_color = "#4c566a"
    timeout = 4

[urgency_normal]
    background = "#2e3440"
    foreground = "#eceff4"
    frame_color = "#81a1c1"
    timeout = 5

[urgency_critical]
    background = "#bf616a"
    foreground = "#eceff4"
    frame_color = "#bf616a"
    timeout = 0
```

> **Important — dunst 1.12.0+ syntax changes:**
>
> - `offset = (10, 40)` not `offset = 10x40`
> - `height = (0, 100)` not `height = 100`

### Notification Sound Scripts

```bash
mkdir -p ~/.local/bin

cat > ~/.local/bin/dunst-notify-sound-low << 'EOF'
#!/bin/bash
play -qn synth 0.08 sine 600 vol 0.2 2>/dev/null &
EOF

cat > ~/.local/bin/dunst-notify-sound-normal << 'EOF'
#!/bin/bash
play -qn synth 0.1 sine 880 vol 0.3 2>/dev/null &
EOF

cat > ~/.local/bin/dunst-notify-sound-critical << 'EOF'
#!/bin/bash
play -qn synth 0.1 sine 880 : synth 0.1 sine 1100 vol 0.5 2>/dev/null &
EOF

chmod +x ~/.local/bin/dunst-notify-sound-*
```

### Test

```bash
notify-send "Test" "Normal notification"
notify-send -u critical "Alert" "Critical notification"
```

---

## 12. Screen Lock

```bash
sudo pacman -S i3lock xautolock
```

Already included in the i3 config above:

```ini
bindsym $mod+Shift+x exec i3lock -c 1e1e2e
exec --no-startup-id xautolock -time 5 -locker 'i3lock -c 1e1e2e'
exec --no-startup-id xss-lock -- i3lock -c 1e1e2e
```

Color `1e1e2e` is a dark navy matching the Nord theme.

---

## 13. Bluetooth

### Install

```bash
sudo pacman -S bluez bluez-utils blueman
sudo systemctl enable --now bluetooth
```

### Auto-enable on Boot

```bash
sudo sed -i 's/#AutoEnable=true/AutoEnable=true/' /etc/bluetooth/main.conf
sudo systemctl restart bluetooth
```

### Pair a Device

```bash
bluetoothctl
power on
agent on
default-agent
scan on
# Wait for your device to appear in the list
pair XX:XX:XX:XX:XX:XX
trust XX:XX:XX:XX:XX:XX
connect XX:XX:XX:XX:XX:XX
scan off
exit
```

### Blueman System Tray

Add to i3 config (already included above):

```ini
exec --no-startup-id blueman-applet
```

---

## 14. Audio — PipeWire

### Install

```bash
sudo pacman -S pipewire pipewire-pulse pipewire-audio wireplumber
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

### Bluetooth Audio — Switch to A2DP (High Quality)

After connecting earbuds, check and switch profile:

```bash
# Find card and sink names
pactl list cards short | grep bluez
pactl list sinks short

# Switch to A2DP (high quality audio, not call mode)
pactl set-card-profile bluez_card.XX_XX_XX_XX_XX_XX a2dp-sink

# Set as default output
pactl set-default-sink bluez_output.XX:XX:XX:XX:XX:XX

# IMPORTANT: Check mute status — most common reason for no sound
pactl get-sink-mute bluez_output.XX:XX:XX:XX:XX:XX

# Unmute if muted
pactl set-sink-mute bluez_output.XX:XX:XX:XX:XX:XX 0
```

### Auto-switch to Bluetooth on Connect

```bash
sudo mkdir -p /etc/pipewire/pipewire-pulse.conf.d
sudo tee /etc/pipewire/pipewire-pulse.conf.d/switch-on-connect.conf << 'EOF'
pulse.cmd = [
    { cmd = "load-module" args = "module-switch-on-connect" flags = [] }
]
EOF

systemctl --user restart pipewire pipewire-pulse
```

---

## 15. File Manager — Yazi

### Install

```bash
sudo pacman -S yazi ueberzugpp
```

### Configure Image Preview in Alacritty

Create `~/.config/yazi/yazi.toml`:

```toml
[preview]
image_protocol = "ueberzug"
```

---

## 16. Neovim

### Install

```bash
sudo pacman -S neovim
```

### Dependencies

```bash
sudo pacman -S \
  nodejs \
  npm \
  python \
  python-pip \
  cargo \
  make \
  gcc \
  ripgrep \
  fd \
  xclip
```

### Config Structure

```
~/.config/nvim/
├── init.lua
└── lua/
    └── neovim/
        ├── core/
        │   ├── keymaps.lua
        │   └── settings.lua
        ├── lazy.lua
        └── plugins/
            ├── cmp.lua
            ├── colorScheme.lua
            ├── format.lua
            ├── init.lua
            ├── lsp.lua
            ├── mason.lua
            ├── oil.lua
            ├── telescope.lua
            ├── term.lua
            ├── todo.lua
            ├── treesitter.lua
            └── trouble.lua
```

### init.lua

```lua
require("neovim.core.keymaps")
require("neovim.core.settings")
require("neovim.lazy")
```

### lazy.lua

```lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({ { import = "neovim.plugins" } }, {
    checker = { enabled = false, notify = false },
    change_detection = { notify = false },
})
```

---

## 17. Neovim Plugins & Config

### Plugin List

| Plugin                            | Purpose                        |
| --------------------------------- | ------------------------------ |
| `nvim-treesitter`                 | Syntax highlighting (v1.x API) |
| `nvim-lspconfig`                  | LSP client (nvim 0.11 API)     |
| `hrsh7th/nvim-cmp`                | Autocompletion                 |
| `williamboman/mason.nvim`         | LSP/formatter installer        |
| `stevearc/conform.nvim`           | Formatting                     |
| `nvim-telescope/telescope.nvim`   | Fuzzy finder                   |
| `stevearc/oil.nvim`               | File manager                   |
| `ThePrimeagen/harpoon` (harpoon2) | Buffer navigation              |
| `folke/trouble.nvim`              | Diagnostics UI                 |
| `folke/todo-comments.nvim`        | Todo highlighting              |
| `folke/noice.nvim`                | UI overhaul                    |
| `folke/which-key.nvim`            | Keybinding hints               |
| `tpope/vim-fugitive`              | Git integration                |
| `ThePrimeagen/git-worktree.nvim`  | Git worktrees                  |
| `mbbill/undotree`                 | Undo history tree              |
| `numToStr/Comment.nvim`           | Comment toggling               |
| `windwp/nvim-autopairs`           | Auto brackets                  |
| `windwp/nvim-ts-autotag`          | Auto HTML tags                 |
| `kylechui/nvim-surround`          | Surround motions               |
| `karb94/neoscroll.nvim`           | Smooth scrolling               |
| `stevearc/dressing.nvim`          | Better vim.ui                  |
| `akinsho/bufferline.nvim`         | Buffer tabs                    |
| `NvChad/nvterm`                   | Terminal splits                |
| `numToStr/FTerm.nvim`             | Floating terminal              |
| `sphamba/smear-cursor.nvim`       | Cursor animation               |
| `ya2s/nvim-cursorline`            | Cursor line highlight          |
| `pmizio/typescript-tools.nvim`    | TypeScript LSP helper          |
| `tversteeg/registers.nvim`        | Register viewer                |
| `folke/neodev.nvim`               | Neovim Lua dev                 |
| `tweekmonster/django-plus.vim`    | Django support                 |

### Critical API Changes

#### nvim-treesitter v1.x

The old `require("nvim-treesitter.configs").setup({})` module is **completely removed** in v1.x.

```lua
-- treesitter.lua
config = function()
    -- Register custom parsers before setup
    local parsers = require("nvim-treesitter.parsers")
    parsers.templ = {
        install_info = {
            url = "https://github.com/vrischmann/tree-sitter-templ.git",
            files = { "src/parser.c", "src/scanner.c" },
            branch = "master",
        },
    }
    vim.treesitter.language.register("templ", "templ")

    -- v1.x setup only accepts install_dir
    require("nvim-treesitter").setup({ auto_install = true })

    -- Highlighting is now native
    vim.api.nvim_create_autocmd("FileType", {
        callback = function() pcall(vim.treesitter.start) end,
    })

    -- Textobjects via nvim-treesitter-textobjects
    require("nvim-treesitter-textobjects").setup({
        select = {
            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer", ["if"] = "@function.inner",
                ["ac"] = "@class.outer",    ["ic"] = "@class.inner",
                ["aa"] = "@parameter.outer",["ia"] = "@parameter.inner",
                ["ai"] = "@conditional.outer", ["ii"] = "@conditional.inner",
                ["al"] = "@loop.outer",    ["il"] = "@loop.inner",
                ["at"] = "@comment.outer",
            },
        },
        move = {
            set_jumps = true,
            goto_next_start  = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
            goto_next_end    = { ["]M"] = "@function.outer", ["]["] = "@class.outer" },
            goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer" },
            goto_previous_end   = { ["[M"] = "@function.outer", ["[]"] = "@class.outer" },
        },
    })

    -- Swap uses direct function calls (no setup API)
    local swap = require("nvim-treesitter-textobjects.swap")
    vim.keymap.set("n", "<leader>pa", function()
        swap.swap_next({ "@parameter.inner" })
    end, { desc = "Swap with next parameter" })
    vim.keymap.set("n", "<leader>pA", function()
        swap.swap_previous({ "@parameter.inner" })
    end, { desc = "Swap with prev parameter" })
end,
```

#### nvim-lspconfig (nvim 0.11+)

The old `require("lspconfig")[server].setup({})` is **deprecated**. Use the new `vim.lsp.config` API:

```lua
-- lsp.lua
-- on_attach replaced by LspAttach autocmd
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
    callback = function(event)
        local opts = { noremap = true, silent = true, buffer = event.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "gR", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "K",  vim.lsp.buf.hover, opts)
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>g",  vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    end,
})

-- Server config (root_dir replaced by root_markers)
vim.lsp.config("clangd", {
    capabilities = capabilities,
    root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
})

vim.lsp.config("lua_ls", { capabilities = capabilities, filetypes = { "lua" } })
vim.lsp.config("ts_ls",  { capabilities = capabilities, filetypes = { "javascript" } })
-- ... other servers

-- Enable all servers at once
vim.lsp.enable({ "lua_ls", "ts_ls", "cssls", "html", "tailwindcss",
                 "emmet_ls", "clangd", "dartls", "intelephense" })
```

### Neovim Keybindings

```
Leader = Space
```

#### File Navigation

| Keybinding   | Action                            |
| ------------ | --------------------------------- |
| `Space + ff` | Find files in cwd                 |
| `Space + fs` | Live grep (ripgrep)               |
| `Space + fw` | Fuzzy find in current buffer      |
| `Space + fb` | Find open buffers                 |
| `Space + fa` | Find all files (including hidden) |
| `Space + fc` | Find nvim config files            |
| `Space + cf` | Change colorscheme                |
| `Space + pv` | Open oil.nvim                     |
| `Space + pf` | Toggle oil float                  |
| `Ctrl + p`   | Git files                         |

#### Harpoon

| Keybinding  | Action                  |
| ----------- | ----------------------- |
| `ha`        | Add current buffer      |
| `hi`        | Toggle harpoon menu     |
| `h1` - `h4` | Jump to slot 1-4        |
| `Alt + i`   | Previous harpoon buffer |
| `Alt + o`   | Next harpoon buffer     |

#### LSP

| Keybinding   | Action                      |
| ------------ | --------------------------- |
| `gR`         | Show references             |
| `gD`         | Go to declaration           |
| `gd`         | Go to definition            |
| `gt`         | Type definition             |
| `gi`         | Implementations (telescope) |
| `gr`         | References (telescope)      |
| `K`          | Hover documentation         |
| `Space + ca` | Code actions                |
| `Space + rn` | Rename symbol               |
| `Space + D`  | Buffer diagnostics          |
| `Space + g`  | Line diagnostics            |
| `[d` / `]d`  | Prev / next diagnostic      |
| `Space + dl` | Diagnostics to quickfix     |

#### Editing

| Keybinding   | Action                             |
| ------------ | ---------------------------------- |
| `Space + u`  | Toggle undotree                    |
| `fj`         | Save file                          |
| `Space + lf` | Format file                        |
| `Space + ss` | Search & replace word under cursor |
| `sa`         | Select all                         |
| `cb`         | Close current buffer               |
| `co`         | Close all other buffers            |
| `Shift + k`  | Next buffer                        |
| `Shift + j`  | Previous buffer                    |
| `U`          | Redo                               |
| `'`          | Enter command mode (replaces `:`)  |

#### Splits & Windows

| Keybinding | Action              |
| ---------- | ------------------- |
| `sr`       | Vertical split      |
| `sd`       | Horizontal split    |
| `sh`       | Focus left window   |
| `sl`       | Focus right window  |
| `sk`       | End of line (`$`)   |
| `sj`       | Start of line (`^`) |

#### Terminal

| Keybinding   | Action                     |
| ------------ | -------------------------- |
| `Space + tt` | Toggle FTerm (floating)    |
| `Alt + t`    | Toggle nvterm (horizontal) |
| `Alt + e`    | Toggle nvterm (float)      |
| `Alt + r`    | Toggle nvterm (vertical)   |
| `jf`         | Exit terminal mode         |

#### Treesitter Textobjects

| Keybinding   | Action                    |
| ------------ | ------------------------- |
| `af` / `if`  | Around/inside function    |
| `ac` / `ic`  | Around/inside class       |
| `aa` / `ia`  | Around/inside parameter   |
| `ai` / `ii`  | Around/inside conditional |
| `al` / `il`  | Around/inside loop        |
| `at`         | Around comment            |
| `]m` / `[m`  | Next/prev function start  |
| `]]` / `[[`  | Next/prev class           |
| `Space + pa` | Swap with next parameter  |
| `Space + pA` | Swap with prev parameter  |

---

## 18. LSP Servers & Formatters

### LSP Servers (auto-installed via mason-lspconfig)

| Server         | Language              |
| -------------- | --------------------- |
| `ts_ls`        | JavaScript/TypeScript |
| `lua_ls`       | Lua                   |
| `html`         | HTML                  |
| `cssls`        | CSS                   |
| `tailwindcss`  | Tailwind CSS          |
| `emmet_ls`     | HTML/CSS emmet        |
| `jsonls`       | JSON                  |
| `yamlls`       | YAML                  |
| `bashls`       | Bash                  |
| `eslint`       | JavaScript linting    |
| `intelephense` | PHP                   |
| `clangd`       | C/C++                 |
| `dartls`       | Dart/Flutter          |
| `templ`        | Templ                 |

### Formatters (via mason-tool-installer)

| Tool           | Language                    |
| -------------- | --------------------------- |
| `prettierd`    | JS/TS/CSS/HTML/JSON/YAML/MD |
| `prettier`     | Fallback formatter          |
| `stylua`       | Lua                         |
| `eslint_d`     | JavaScript                  |
| `shfmt`        | Shell                       |
| `black`        | Python                      |
| `php-cs-fixer` | PHP                         |

> **Important:** `php-cs-fixer` must be in `mason-tool-installer`, NOT `mason-lspconfig`. It is a formatter, not an LSP server.

---

## 19. Shell & CLI Tools

```bash
sudo pacman -S \
  zsh \
  starship \
  zoxide \
  eza \
  bat \
  lazygit \
  gimp
```

---

## 20. Dotfiles Setup with Symlinks

Keep actual config files in `~/dotfiles/` and symlink from the expected locations. Edit in `~/dotfiles/`, changes reflect everywhere automatically.

### Initial Setup

```bash
mkdir -p ~/dotfiles
cd ~/dotfiles
git init

# Move configs into dotfiles and create symlinks
mv ~/.config/nvim ~/dotfiles/nvim
ln -sf ~/dotfiles/nvim ~/.config/nvim

mv ~/.config/i3 ~/dotfiles/i3
ln -sf ~/dotfiles/i3 ~/.config/i3

mv ~/.config/i3blocks ~/dotfiles/i3blocks
ln -sf ~/dotfiles/i3blocks ~/.config/i3blocks

mv ~/.config/alacritty ~/dotfiles/alacritty
ln -sf ~/dotfiles/alacritty ~/.config/alacritty

mv ~/.config/yazi ~/dotfiles/yazi
ln -sf ~/dotfiles/yazi ~/.config/yazi

mv ~/.config/dunst ~/dotfiles/dunst
ln -sf ~/dotfiles/dunst ~/.config/dunst

mv ~/.tmux.conf ~/dotfiles/.tmux.conf
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf

mv ~/.tmux ~/dotfiles/.tmux
ln -sf ~/dotfiles/.tmux ~/.tmux
```

### Push to GitHub

```bash
cd ~/dotfiles
git add .
git commit -m "initial dotfiles"
git remote add origin https://github.com/yourusername/dotfiles.git
git push -u origin main
```

### Restore on a New Machine

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles

ln -sf ~/dotfiles/nvim ~/.config/nvim
ln -sf ~/dotfiles/i3 ~/.config/i3
ln -sf ~/dotfiles/i3blocks ~/.config/i3blocks
ln -sf ~/dotfiles/alacritty ~/.config/alacritty
ln -sf ~/dotfiles/yazi ~/.config/yazi
ln -sf ~/dotfiles/dunst ~/.config/dunst
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.tmux ~/.tmux
```

---

## 21. System Maintenance

### Clean Caches

```bash
# Pacman — keep 1 version per package
sudo paccache -rk1
sudo paccache -ruk0

# AUR cache
yay -Sc --noconfirm

# Neovim cache
rm -rf ~/.cache/nvim

# npm
npm cache clean --force

# Journal logs older than 2 weeks
sudo journalctl --vacuum-time=2weeks

# Temp files
sudo rm -rf /tmp/*

# Flutter cache (if applicable, ~1.2GB)
rm -rf ~/.cache/flutter_local
rm -rf ~/.cache/flutter_sdk

# Check what's taking space
du -sh ~/.cache/* | sort -rh | head -20
df -h
```

---

## 22. Keybindings Reference

### i3

| Binding             | Action                   |
| ------------------- | ------------------------ |
| `Alt + Return`      | Terminal                 |
| `Alt + f / z`       | Firefox / Zen Browser    |
| `Alt + d`           | App launcher (dmenu)     |
| `Alt + q`           | Close window             |
| `Alt + h / l`       | Focus left / right       |
| `Alt + j / k`       | Prev / next workspace    |
| `Alt + 1-4`         | Go to workspace          |
| `Alt + Shift + 1-4` | Move window to workspace |
| `Alt + v`           | Volume mode              |
| `Alt + b`           | Brightness mode          |
| `Alt + r`           | Resize mode              |
| `Alt + Shift + x`   | Lock screen              |
| `Alt + Shift + r`   | Restart i3               |
| `Alt + Shift + c`   | Reload config            |

### Tmux (Prefix = Tab)

| Binding         | Action               |
| --------------- | -------------------- |
| `Tab + /`       | Vertical split       |
| `Tab + ;`       | Horizontal split     |
| `Tab + h/j/k/l` | Navigate panes       |
| `Tab + n`       | New session          |
| `Tab + s`       | Rename session       |
| `Tab + i`       | Rename window        |
| `Tab + t`       | Switch session (fzf) |
| `Tab + u`       | Switch window (fzf)  |
| `Tab + p`       | Kill window          |
| `Tab + Ctrl+s`  | Save session         |
| `Tab + Ctrl+r`  | Restore session      |
| `M-[ / M-]`     | Prev / next window   |

### Neovim (Leader = Space)

| Binding      | Action                   |
| ------------ | ------------------------ |
| `Space + ff` | Find files               |
| `Space + fs` | Live grep                |
| `Space + fb` | Buffers                  |
| `ha / hi`    | Harpoon add / menu       |
| `h1-h4`      | Harpoon jump             |
| `gd / gD`    | Definition / declaration |
| `K`          | Hover docs               |
| `Space + ca` | Code actions             |
| `Space + rn` | Rename symbol            |
| `fj`         | Save                     |
| `cb`         | Close buffer             |
| `co`         | Close all other buffers  |
| `Space + lf` | Format file              |

---

## 23. Troubleshooting

### i3 doesn't start

```bash
i3 -C                          # Check config syntax
journalctl -b | grep i3        # Check startup logs
```

### Neovim plugin errors on startup

```bash
# Full clean reinstall
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim
nvim   # lazy.nvim reinstalls everything automatically
```

### LSP not working

```bash
:LspInfo        # Check active LSP servers
:Mason          # Check installed servers
:LspLog         # View LSP logs
```

### Treesitter errors

```bash
# Reinstall specific parsers
:lua require("nvim-treesitter.install").install({"lua", "javascript", "typescript"})
```

### Dunst not showing notifications

```bash
pgrep dunst                        # Check if running
pkill dunst && dunst &             # Restart
notify-send "test" "message"       # Test
```

### Brightness control not working

```bash
brightnessctl list                 # List devices
sudo usermod -aG video $USER       # Fix permissions
# Logout and log back in for group change to take effect
```

### Volume not working

```bash
pactl get-default-sink             # Check active sink
pamixer --get-volume               # Test pamixer
pactl list sinks short             # List all sinks
```

### Bluetooth audio — no sound

```bash
# Step 1: Check mute status (most common issue!)
pactl get-sink-mute bluez_output.XX:XX:XX:XX:XX:XX
pactl set-sink-mute bluez_output.XX:XX:XX:XX:XX:XX 0

# Step 2: Verify A2DP profile is active
pactl list cards | grep "Active Profile"
pactl set-card-profile bluez_card.XX_XX_XX_XX_XX_XX a2dp-sink

# Step 3: Set as default output
pactl set-default-sink bluez_output.XX:XX:XX:XX:XX:XX

# Step 4: Restart audio stack if nothing works
systemctl --user restart pipewire pipewire-pulse
sudo systemctl restart bluetooth
```

### Tmux sessions not restoring

```bash
~/.tmux/plugins/tmux-resurrect/scripts/restore.sh
ls ~/.tmux/resurrect/             # Check saved sessions exist
```

### Fonts not rendering correctly

```bash
fc-cache -fv
fc-list | grep -i "JetBrains"
```

---

## 24. Full Package List

All packages installed on this machine, in install order:

```bash
# 1. Core system tools
sudo pacman -S base-devel git curl wget unzip zip tar man-db man-pages reflector pacman-contrib

# 2. Network
sudo pacman -S networkmanager nm-connection-editor network-manager-applet
sudo systemctl enable --now NetworkManager

# 3. AUR helper
cd /tmp && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

# 4. Fonts
sudo pacman -S ttf-jetbrains-mono-nerd ttf-firacode-nerd noto-fonts noto-fonts-emoji ttf-font-awesome
fc-cache -fv

# 5. Display & Window Manager
sudo pacman -S xorg xorg-xinit xorg-server xorg-xrandr i3 i3status i3lock i3blocks dmenu dex xss-lock xautolock feh picom

# 6. Terminal
sudo pacman -S alacritty tmux

# 7. Audio
sudo pacman -S pipewire pipewire-pulse pipewire-audio wireplumber pamixer
systemctl --user enable --now pipewire pipewire-pulse wireplumber

# 8. Bluetooth
sudo pacman -S bluez bluez-utils blueman
sudo systemctl enable --now bluetooth

# 9. Notifications & sounds
sudo pacman -S dunst libnotify libcanberra sox

# 10. Brightness & Volume
sudo pacman -S brightnessctl

# 11. Neovim & dependencies
sudo pacman -S neovim nodejs npm python python-pip cargo make gcc

# 12. CLI tools
sudo pacman -S ripgrep fd fzf bat eza zoxide lazygit xclip btop tree xdotool playerctl

# 13. File manager & image editing
sudo pacman -S yazi ueberzugpp gimp

# 14. AUR packages
yay -S zen-browser discord
```

---

_Last updated: March 2026_
