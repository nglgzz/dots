#!/usr/bin/env sh
# Environment variables
SCREEN_WIDTH=$(xrandr | grep -w connected | awk '{print $4}' | sed 's/x.*//' | head -n1)

## Bar settings
export MONITOR=$(xrandr | grep -w connected | awk '{print $1}' | head -n1)
export POLYBAR_WIDTH=$(expr $SCREEN_WIDTH - 80 || expr 1366 - 80)
export NETWORK_IFACE=$(ip link show up  | grep -oP '(?<=^\d: )\w+' | tail -n1)


# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch polybar
polybar $1 &
