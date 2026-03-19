#!/bin/bash

# Kill already running bar instances
killall -q polybar

# Wait until processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch polybar on primary monitor
polybar mybar &
