#!/usr/bin/env sh

# Terminate existing processes and wait for them to exit.
pkill polybar -9
while pgrep -x polybar >/dev/null; do sleep .25; done

# Spawn an instance of polybar for each screen.
polybar --list-monitors | while read -r screen; do
  SCREEN_WIDTH=$(echo "$screen" | cut -d":" -f2 | sed 's/x.*//')

  SCREEN_NAME="$(echo "$screen" | cut -d":" -f1)"
  POLYBAR_WIDTH=$(expr "$SCREEN_WIDTH" - 80 || expr 1920 - 80)

  # TODO -- Update this to generate a network component per interface.
  NETWORK_IFACE=$(ip link show | grep -iP 'state up' | grep -oP '^\d+: \K(\w+)')

  export SCREEN_NAME
  export POLYBAR_WIDTH
  export NETWORK_IFACE

  polybar --reload top &
  polybar --reload bottom &
done
