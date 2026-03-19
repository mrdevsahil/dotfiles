# 🖥️ Arch Linux Developer Workstation Setup

> A complete, battle-tested guide to setting up Arch Linux with i3, Neovim, Tmux, Alacritty, and a full developer environment from scratch.

---

## 📋 Table of Contents

- [Base Arch Installation](#base-arch-installation)
- [Essential System Packages](#essential-system-packages)
- [AUR Helper](#aur-helper)
- [Display Server & i3 Window Manager](#display-server--i3-window-manager)
- [i3 Configuration](#i3-configuration)
- [Alacritty Terminal](#alacritty-terminal)
- [Tmux](#tmux)
- [Neovim](#neovim)
- [Neovim Plugins & Config](#neovim-plugins--config)
- [LSP Servers](#lsp-servers)
- [Shell & CLI Tools](#shell--cli-tools)
- [File Manager — Yazi](#file-manager--yazi)
- [Notifications — Dunst](#notifications--dunst)
- [Screen Lock](#screen-lock)
- [Fonts](#fonts)
- [Dotfiles Setup with Symlinks](#dotfiles-setup-with-symlinks)
- [Keybindings Reference](#keybindings-reference)
- [Troubleshooting](#troubleshooting)

---

## Base Arch Installation

> This guide assumes Arch is already installed. If not, follow the [Arch Installation Guide](https://wiki.archlinux.org/title/Installation_guide).

After base install, make sure the system is up to date:

```bash
sudo pacman -Syu
```

---

## Essential System Packages

Install all core dependencies at once:

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
  network-manager-applet
```

Enable NetworkManager:

```bash
sudo systemctl enable --now NetworkManager
```

---

## AUR Helper

Install `yay` for AUR package access:

```bash
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

---

## Display Server & i3 Window Manager

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
  dmenu \
  dex \
  xss-lock \
  xautolock \
  feh \
  picom
```

### Start i3 on Login

Create or edit `~/.xinitrc`:

```bash
echo "exec i3" >> ~/.xinitrc
```

Auto-start X on login by adding to `~/.bash_profile` or `~/.zprofile`:

```bash
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = "1" ]; then
  exec startx
fi
```

### Set Wallpaper with feh

```bash
# Set wallpaper
feh --bg-scale /path/to/wallpaper.jpg

# feh saves the command to ~/.fehbg — i3 exec's this on startup
# Add to i3 config:
# exec --no-startup-id ~/.fehbg
```

---

## i3 Configuration

Location: `~/.config/i3/config`

### Key Bindings Overview

```
$mod = Mod1 (Alt key)
```

### Window Management

| Keybinding | Action |
|---|---|
| `Alt + Return` | Open Alacritty terminal |
| `Alt + f` | Open Firefox |
| `Alt + z` | Open Zen Browser |
| `Alt + d` | Open dmenu launcher |
| `Alt + q` | Kill focused window |
| `Alt + h` | Focus left |
| `Alt + l` | Focus right |
| `Alt + j` | Previous workspace |
| `Alt + k` | Next workspace |
| `Alt + Shift + j` | Move window left |
| `Alt + Shift + k` | Move window down |
| `Alt + Shift + l` | Move window up |
| `Alt + Shift + ;` | Move window right |
| `Alt + Shift + Space` | Toggle floating |
| `Alt + Space` | Focus mode toggle |
| `Alt + Shift + f` | Fullscreen toggle |
| `Alt + 1-4` | Switch to workspace 1-4 |
| `Alt + Shift + 1-4` | Move window to workspace 1-4 |

### Modes

| Keybinding | Mode |
|---|---|
| `Alt + v` | Volume mode |
| `Alt + b` | Brightness mode |
| `Alt + r` | Resize mode |

#### Volume Mode (`Alt + v`)

| Key | Action |
|---|---|
| `j` | Volume down 5% |
| `k` | Volume up 5% |
| `m` | Toggle mute |
| `Escape / Enter` | Exit mode |

#### Brightness Mode (`Alt + b`)

| Key | Action |
|---|---|
| `j` | Brightness down 15% |
| `k` | Brightness up 15% |
| `Escape / Enter` | Exit mode |

#### Resize Mode (`Alt + r`)

| Key | Action |
|---|---|
| `j` | Shrink width |
| `k` | Grow width |
| `Escape / Enter` | Exit mode |

### System

| Keybinding | Action |
|---|---|
| `Alt + Shift + c` | Reload i3 config |
| `Alt + Shift + r` | Restart i3 |
| `Alt + Shift + e` | Exit i3 |
| `Alt + Shift + x` | Lock screen |

### Dependencies for Volume & Brightness

```bash
sudo pacman -S pamixer brightnessctl libnotify
```

Brightness notify script — create `~/.local/bin/brightness-notify`:

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

### Theme / Colors

The config uses a Nord-inspired dark theme:

```ini
client.focused         #2e3440 #2e3440 #eceff4 #81a1c1 #2e3440
client.unfocused       #2e3440 #2e3440 #d8dee9 #4c566a #2e3440
client.background      #1e1e2e
```

---

## Alacritty Terminal

### Install

```bash
sudo pacman -S alacritty
```

### Image Preview Support (for Yazi)

```bash
sudo pacman -S ueberzugpp
```

---

## Tmux

### Install

```bash
sudo pacman -S tmux
```

### Install TPM (Tmux Plugin Manager)

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### Plugins Used

| Plugin | Purpose |
|---|---|
| `tmux-plugins/tmux-sensible` | Sensible defaults |
| `tmux-plugins/tmux-resurrect` | Save/restore sessions across reboots |
| `tmux-plugins/tmux-continuum` | Auto-save every 15 minutes |
| `egel/tmux-gruvbox` | Gruvbox theme |

### Install Plugins

After setting up `.tmux.conf`, open tmux and run:

```bash
~/.tmux/plugins/tpm/bin/install_plugins
```

Or press `Tab + I` inside tmux.

### Key Bindings

```
Prefix = Tab
```

| Keybinding | Action |
|---|---|
| `Tab + r` | Reload tmux config |
| `Tab + /` | Split pane vertically |
| `Tab + ;` | Split pane horizontally |
| `Tab + h/j/k/l` | Navigate panes (vim style) |
| `Tab + p` | Kill window (with confirm) |
| `Tab + i` | Rename window |
| `Tab + s` | Rename session |
| `Tab + n` | New session |
| `Tab + t` | Session switcher (fzf) |
| `Tab + u` | Window switcher (fzf) |
| `Tab + Ctrl+s` | Save session (resurrect) |
| `Tab + Ctrl+r` | Restore session (resurrect) |
| `M-[` | Previous window |
| `M-]` | Next window |

### Session Persistence

Sessions are auto-saved every 15 minutes via `tmux-continuum` and automatically restored when tmux starts.

```bash
# Manual save
Tab + Ctrl+s

# Restore is automatic on tmux start due to:
# set -g @continuum-restore 'on'
```

---

## Neovim

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

### Plugin Manager — lazy.nvim

lazy.nvim bootstraps itself automatically from `lazy.lua`. No manual install needed.

---

## Neovim Plugins & Config

### Core Plugins

| Plugin | Purpose |
|---|---|
| `folke/lazy.nvim` | Plugin manager |
| `nvim-treesitter` | Syntax highlighting (v1.x API) |
| `nvim-lspconfig` | LSP client (nvim 0.11 `vim.lsp.config` API) |
| `hrsh7th/nvim-cmp` | Autocompletion |
| `williamboman/mason.nvim` | LSP/formatter installer |
| `stevearc/conform.nvim` | Formatting |
| `nvim-telescope/telescope.nvim` | Fuzzy finder |
| `stevearc/oil.nvim` | File manager |
| `ThePrimeagen/harpoon` | Buffer navigation |
| `folke/trouble.nvim` | Diagnostics UI |
| `folke/todo-comments.nvim` | Todo highlighting |
| `folke/noice.nvim` | UI overhaul |
| `folke/which-key.nvim` | Keybinding hints |
| `tpope/vim-fugitive` | Git integration |
| `ThePrimeagen/git-worktree.nvim` | Git worktrees |
| `mbbill/undotree` | Undo history |
| `numToStr/Comment.nvim` | Comment toggling |
| `windwp/nvim-autopairs` | Auto brackets |
| `windwp/nvim-ts-autotag` | Auto HTML tags |
| `kylechui/nvim-surround` | Surround motions |
| `karb94/neoscroll.nvim` | Smooth scrolling |
| `stevearc/dressing.nvim` | Better vim.ui |
| `akinsho/bufferline.nvim` | Buffer tabs |
| `NvChad/nvterm` | Terminal |
| `numToStr/FTerm.nvim` | Floating terminal |
| `sphamba/smear-cursor.nvim` | Cursor animation |
| `ya2s/nvim-cursorline` | Cursor line highlight |
| `laytan/cloak.nvim` | *(removed)* Hide env values |
| `pmizio/typescript-tools.nvim` | TypeScript LSP helper |
| `tversteeg/registers.nvim` | Register viewer |

### Important Notes on Plugin APIs

#### nvim-treesitter v1.x

The old `require("nvim-treesitter.configs").setup({})` API is **removed** in v1.x. The correct setup:

```lua
-- treesitter.lua
require("nvim-treesitter").setup({ auto_install = true })

-- Highlighting is handled natively:
vim.api.nvim_create_autocmd("FileType", {
  callback = function() pcall(vim.treesitter.start) end,
})

-- Textobjects via nvim-treesitter-textobjects:
require("nvim-treesitter-textobjects").setup({ ... })
```

#### nvim-lspconfig (nvim 0.11+)

The old `require("lspconfig")[server].setup({})` pattern is deprecated. Use:

```lua
vim.lsp.config("server_name", { capabilities = ..., filetypes = ... })
vim.lsp.enable({ "server_name" })
```

`on_attach` is replaced by:

```lua
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    -- set keymaps here using event.buf
  end,
})
```

`root_dir = utils.root_pattern(...)` is replaced by:

```lua
root_markers = { "package.json", ".git" }
```

### Neovim Keybindings

```
Leader = Space
```

#### File Navigation

| Keybinding | Action |
|---|---|
| `<leader>ff` | Find files in cwd |
| `<leader>fs` | Live grep (ripgrep) |
| `<leader>fw` | Fuzzy find in current buffer |
| `<leader>fb` | Find open buffers |
| `<leader>fa` | Find all files (including hidden) |
| `<leader>fc` | Find nvim config files |
| `<leader>cf` | Change colorscheme |
| `<leader>pv` | Open oil.nvim |
| `<leader>pf` | Toggle oil float |
| `<C-p>` | Git files |

#### Harpoon

| Keybinding | Action |
|---|---|
| `ha` | Add current buffer |
| `hi` | Toggle harpoon menu |
| `h1` - `h4` | Jump to harpoon slot 1-4 |
| `A-i` | Previous harpoon buffer |
| `A-o` | Next harpoon buffer |

#### LSP

| Keybinding | Action |
|---|---|
| `gR` | Show references |
| `gD` | Go to declaration |
| `gd` | Go to definition |
| `gt` | Go to type definition |
| `gi` | Show implementations |
| `gr` | LSP references (telescope) |
| `K` | Hover documentation |
| `<leader>ca` | Code actions |
| `<leader>rn` | Rename symbol |
| `<leader>D` | Buffer diagnostics |
| `<leader>g` | Line diagnostics |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `<leader>dl` | Diagnostics to quickfix |

#### Editing

| Keybinding | Action |
|---|---|
| `<leader>u` | Toggle undotree |
| `fj` | Save file |
| `<leader>lf` | Format file |
| `<leader>ss` | Search and replace word under cursor |
| `sa` | Select all |
| `cb` | Close current buffer |
| `co` | Close all other buffers |
| `<S-k>` | Next buffer |
| `<S-j>` | Previous buffer |
| `<leader>/` | Comment toggle (visual) |
| `U` | Redo |

#### Splits & Windows

| Keybinding | Action |
|---|---|
| `sr` | Vertical split |
| `sd` | Horizontal split |
| `sh` | Move to left window |
| `sl` | Move to right window |
| `sk` | End of line |
| `sj` | Start of line |

#### Terminal

| Keybinding | Action |
|---|---|
| `<leader>tt` | Toggle FTerm (floating) |
| `A-t` | Toggle nvterm (horizontal) |
| `A-e` | Toggle nvterm (float) |
| `A-r` | Toggle nvterm (vertical) |
| `jf` | Exit terminal mode |

#### Treesitter Textobjects

| Keybinding | Action |
|---|---|
| `af` / `if` | Around/inside function |
| `ac` / `ic` | Around/inside class |
| `aa` / `ia` | Around/inside parameter |
| `ai` / `ii` | Around/inside conditional |
| `al` / `il` | Around/inside loop |
| `at` | Around comment |
| `]m` / `[m` | Next/prev function start |
| `]]` / `[[` | Next/prev class |
| `<leader>pa` | Swap with next parameter |
| `<leader>pA` | Swap with prev parameter |

---

## LSP Servers

### Install via Mason

Open Neovim and run:

```
:MasonInstall <server>
```

Or they auto-install via `mason-lspconfig`. Servers configured:

| Server | Language |
|---|---|
| `ts_ls` | JavaScript/TypeScript |
| `lua_ls` | Lua |
| `html` | HTML |
| `cssls` | CSS |
| `tailwindcss` | Tailwind CSS |
| `emmet_ls` | HTML/CSS emmet |
| `jsonls` | JSON |
| `yamlls` | YAML |
| `bashls` | Bash |
| `eslint` | JavaScript linting |
| `intelephense` | PHP |
| `clangd` | C/C++ |
| `dartls` | Dart/Flutter |
| `templ` | Templ |

### Formatters via mason-tool-installer

| Tool | Language |
|---|---|
| `prettierd` | JS/TS/CSS/HTML/JSON/YAML/MD |
| `prettier` | Fallback formatter |
| `stylua` | Lua |
| `eslint_d` | JavaScript |
| `shfmt` | Shell |
| `black` | Python |
| `php-cs-fixer` | PHP |

---

## Shell & CLI Tools

```bash
sudo pacman -S \
  zsh \
  starship \
  zoxide \
  eza \
  bat \
  lazygit \
  ripgrep \
  fd \
  fzf \
  tmux \
  yazi \
  gimp
```

---

## File Manager — Yazi

### Install

```bash
sudo pacman -S yazi ueberzugpp
```

### Configure Image Preview

Create `~/.config/yazi/yazi.toml`:

```toml
[preview]
image_protocol = "ueberzug"
```

---

## Notifications — Dunst

### Install

```bash
sudo pacman -S dunst libnotify libcanberra sox
```

### Config Location

`~/.config/dunst/dunstrc`

### Key Config

```ini
[global]
    origin = top-right
    offset = (10, 40)
    width = 300
    height = (0, 100)
    gap_size = 6
    corner_radius = 8
    font = Monospace 10
    frame_color = "#81a1c1"

[urgency_low]
    background = "#2e3440"
    foreground = "#d8dee9"
    timeout = 4

[urgency_normal]
    background = "#2e3440"
    foreground = "#eceff4"
    timeout = 5

[urgency_critical]
    background = "#bf616a"
    foreground = "#eceff4"
    timeout = 0
```

> **Note on syntax:** dunst 1.12.0+ requires new syntax:
> - `offset = (10, 40)` not `offset = 10x40`
> - `height = (0, 100)` not `height = 100`

### Notification Sound Scripts

```bash
mkdir -p ~/.local/bin

# Per-urgency sound scripts
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

### Auto-start with i3

Add to `~/.config/i3/config`:

```ini
exec --no-startup-id pkill dunst; dunst
```

### Test

```bash
notify-send "Test" "Dunst is working"
notify-send -u critical "Alert" "Critical notification"
```

---

## Screen Lock

### Install

```bash
sudo pacman -S i3lock xautolock
```

### i3 Config

```ini
# Manual lock
bindsym $mod+Shift+x exec i3lock -c 1e1e2e

# Auto-lock after 5 minutes
exec --no-startup-id xautolock -time 5 -locker 'i3lock -c 1e1e2e'

# Lock on sleep/suspend
exec --no-startup-id xss-lock -- i3lock -c 1e1e2e
```

---

## Fonts

```bash
sudo pacman -S \
  ttf-jetbrains-mono-nerd \
  ttf-firacode-nerd \
  noto-fonts \
  noto-fonts-emoji \
  ttf-font-awesome
```

Refresh font cache:

```bash
fc-cache -fv
```

---

## Dotfiles Setup with Symlinks

### Structure

Keep actual files in `~/dotfiles/` and symlink from expected config locations:

```bash
mkdir -p ~/dotfiles
cd ~/dotfiles
git init
```

### Move Configs & Create Symlinks

```bash
# Neovim
mv ~/.config/nvim ~/dotfiles/nvim
ln -sf ~/dotfiles/nvim ~/.config/nvim

# i3
mv ~/.config/i3 ~/dotfiles/i3
ln -sf ~/dotfiles/i3 ~/.config/i3

# Alacritty
mv ~/.config/alacritty ~/dotfiles/alacritty
ln -sf ~/dotfiles/alacritty ~/.config/alacritty

# Yazi
mv ~/.config/yazi ~/dotfiles/yazi
ln -sf ~/dotfiles/yazi ~/.config/yazi

# Dunst
mv ~/.config/dunst ~/dotfiles/dunst
ln -sf ~/dotfiles/dunst ~/.config/dunst

# Tmux
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

# Then recreate all symlinks
ln -sf ~/dotfiles/nvim ~/.config/nvim
ln -sf ~/dotfiles/i3 ~/.config/i3
ln -sf ~/dotfiles/alacritty ~/.config/alacritty
ln -sf ~/dotfiles/yazi ~/.config/yazi
ln -sf ~/dotfiles/dunst ~/.config/dunst
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.tmux ~/.tmux
```

---

## Keybindings Reference

### i3 Quick Reference

| Binding | Action |
|---|---|
| `Alt + Return` | Terminal |
| `Alt + d` | App launcher |
| `Alt + q` | Close window |
| `Alt + v` | Volume mode |
| `Alt + b` | Brightness mode |
| `Alt + r` | Resize mode |
| `Alt + Shift + x` | Lock screen |
| `Alt + Shift + r` | Restart i3 |
| `Alt + j/k` | Switch workspaces |
| `Alt + 1-4` | Go to workspace |

### Tmux Quick Reference

| Binding | Action |
|---|---|
| `Tab + /` | Vertical split |
| `Tab + ;` | Horizontal split |
| `Tab + h/j/k/l` | Navigate panes |
| `Tab + n` | New session |
| `Tab + t` | Switch session (fzf) |
| `Tab + Ctrl+s` | Save session |
| `M-[ / M-]` | Switch windows |

### Neovim Quick Reference

| Binding | Action |
|---|---|
| `Space + ff` | Find files |
| `Space + fs` | Live grep |
| `Space + fb` | Buffers |
| `ha` | Harpoon add |
| `hi` | Harpoon menu |
| `h1-h4` | Harpoon jump |
| `gd` | Go to definition |
| `K` | Hover docs |
| `Space + ca` | Code actions |
| `Space + rn` | Rename |
| `fj` | Save |
| `cb` | Close buffer |
| `co` | Close other buffers |

---

## Troubleshooting

### i3 doesn't start
```bash
# Check for config errors
i3 -C
# Check logs
journalctl -b | grep i3
```

### Neovim plugin errors on startup
```bash
# Clear all cache and reinstall
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim
nvim  # lazy will reinstall everything
```

### LSP not working
```bash
# Check LSP status in neovim
:LspInfo
:Mason
# Check logs
:LspLog
```

### Treesitter errors
```bash
# Reinstall parsers
:lua require("nvim-treesitter.install").install({"lua", "javascript", ...})
```

### Dunst not showing notifications
```bash
# Check if dunst is running
pgrep dunst
# Restart dunst
pkill dunst && dunst &
# Test
notify-send "test" "message"
```

### Brightness control not working
```bash
# Check device
brightnessctl list
# Set permissions
sudo usermod -aG video $USER
# Logout and back in
```

### Volume control not working
```bash
# Check default sink
pactl get-default-sink
# Test pamixer
pamixer -i 5
pamixer --get-volume
```

### Tmux sessions not restoring
```bash
# Manually trigger restore
~/.tmux/plugins/tmux-resurrect/scripts/restore.sh
# Check saved sessions
ls ~/.tmux/resurrect/
```

### Fonts not rendering correctly
```bash
fc-cache -fv
# Check available fonts
fc-list | grep -i "JetBrains"
```

---

## Full Package List

All packages installed on this machine:

```bash
# Core system
sudo pacman -S base-devel git curl wget unzip zip tar

# Display & WM
sudo pacman -S xorg xorg-xinit i3 i3status i3lock dmenu dex xss-lock xautolock feh

# Terminal
sudo pacman -S alacritty tmux

# Neovim
sudo pacman -S neovim nodejs npm python python-pip cargo make gcc

# Fonts
sudo pacman -S ttf-jetbrains-mono-nerd ttf-firacode-nerd noto-fonts noto-fonts-emoji

# CLI tools
sudo pacman -S ripgrep fd fzf bat eza zoxide lazygit yazi ueberzugpp gimp

# Audio/Brightness
sudo pacman -S pamixer brightnessctl libnotify dunst sox libcanberra

# Clipboard
sudo pacman -S xclip

# Network
sudo pacman -S networkmanager network-manager-applet

# Browsers (AUR)
yay -S zen-browser
```

---

*Last updated: March 2026*
