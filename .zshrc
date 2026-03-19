source $ZSH/oh-my-zsh.sh

ZSH_THEME="robbyrussell"

autoload -Uz compinit
compinit

### --- NVIDIA GPU
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export __NV_PRIME_RENDER_OFFLOAD=1
export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0

### Alias ###
alias lsa='exa -lah --git --icons'
alias ll='ls -la'
alias cl='clear'
alias e='exit'
alias so='source'

# NeoVim
alias vi='nvim'
alias vim='nvim'

# Change dir
alias ..='cd ..'
alias home='cd ~'
alias h='home'

# Navigations
alias i3conf='cd ~/.config/i3/'
alias viconf='cd ~/.config/nvim/'
alias work='cd ~/Profession/'
alias office='cd ~/Profession/Office/Recycle_Bazzar/'
alias metime='cd ~/Profession/Projects/'

# git
alias gs='git status'
alias gmm='git merge main'
alias gplm='git pull origin main'
alias ga='git add'
alias gA='git add .'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git pull'

# tmux
alias tls='tmux ls'
alias ts="./script/tmux_session.sh"
alias ta="./script/tmux_session_switch.sh"

# docker
alias dps='sudo docker ps'
alias dim='sudo docker images'

# External monitor aliases
alias hdmi-ext='xrandr --output HDMI-1 --mode 1920x1080 --rate 60 --right-of eDP-1 --auto'
alias hdmi-mirror='xrandr --output HDMI-1 --mode 1920x1080 --same-as eDP-1'
alias hdmi-only='xrandr --output eDP-1 --off --output HDMI-1 --mode 1920x1080 --rate 60'
alias hdmi-off='xrandr --output HDMI-1 --off --output eDP-1 --auto'

# Reload zsh configuration
alias reload="source ~/.zshrc"

# run c++ program
alias rcpp='function _runcpp(){
  local dir=$(dirname "$1")
  local output_dir="$dir/outputs"
  mkdir -p "$output_dir" && g++ -o "$output_dir/$(basename "${1%.cpp}")" "$1" && "$output_dir/$(basename "${1%.cpp}")"
}; _runcpp'

# Flutter
alias flt='flutter'

# Flameshot
alias fui='flameshot gui'
alias ful='flameshot full'

# bat
alias cat='bat'

compdef _files rcpp

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

### Android emulator config
# List all AVDs
alias avdlist="$HOME/Android/Sdk/emulator/emulator -list-avds"
# Create an AVD
avdcreate() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Usage: avdcreate <AVD_NAME> <SYSTEM_IMAGE_PATH>"
        return 1
    fi
    echo "Creating AVD '$1' with system image '$2'..."
    $HOME/Android/Sdk/cmdline-tools/latest/bin/avdmanager create avd -n "$1" -k "$2" --force
}
# Run an AVD
avdrun() {
    if [ -z "$1" ]; then
        echo "Usage: avdrun <AVD_NAME>"
        return 1
    fi
    echo "Starting AVD '$1'..."
    $HOME/Android/Sdk/emulator/emulator -avd "$1"
}

# yazi
alias ff='yazi'
export PATH="$PATH":"$HOME/.pub-cache/bin"
