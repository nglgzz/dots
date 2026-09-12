#!/bin/bash -e
#
# Run with DEBUG_SETTINGS=1 to output debug.gnome.*.ini files containting the
# full set of properties before they're filtered.


declare -A settings_pick_keys=(
  [/org/gnome/settings-daemon/plugins/]='color media-keys media-keys/custom-keybindings/custom0'
  [/org/gnome/shell/extensions/]='appindicator paperwm paperwm/keybindings'
  [/org/gnome/desktop/]='background input-sources interface peripherals/mouse peripherals/touchpad privacy screensaver wm/keybindings wm/preferences'
  [/org/gnome/]='mutter shell system/location'
)

declare -A settings_omit_nested_keys=(
  [/org/gnome/settings-daemon/plugins/]=''
  [/org/gnome/shell/extensions/]=''
  [/org/gnome/desktop/]=''
  [/org/gnome/]='app-picker-layout favorite-apps remember-mount-password'
)

function save-settings() {
    local settings_path=$1
    local output_filename=$2
    local gnome_path="${HOME}/dots/gnome"

    settings=$(dconf dump "$settings_path")
    pick_keys=$(
      jq --null-input --raw-input \
        --compact-output \
        'inputs | split(" ")' <<< "${settings_pick_keys["$settings_path"]}"
    )
    omit_nested_keys=$(
      jq --null-input --raw-input \
        --compact-output \
        'inputs | split(" ")' <<< "${settings_omit_nested_keys["$settings_path"]}"
    )

    # Replace hex colors '#ABC123' to use backticks `#ABC123`, so yq can
    # properly parse strings that contain comment characters.
    #
    # shellcheck disable=SC2001,SC2016
    escaped_settings=$(sed -r 's/'\''(#\w{6,8})'\''/`\1`/g' <<< "${settings}")

    filtered_settings=$(
      echo "$escaped_settings" | yq \
        --input-format ini \
        --output-format ini \
        --ini-preserve-quotes \
        "pick(${pick_keys}) | .[] |= omit(${omit_nested_keys})"
    )

    if [[ $DEBUG_SETTINGS == "1" ]]; then
      debug_output_path="${gnome_path}/debug.${output_filename}"
      echo "$settings" > "$debug_output_path"
      echo -e "$settings_path\t$debug_output_path"
    fi

    # Replace hex colors back to using single quotes '#ABC123' as dconf doesn't
    # understand backticks.
    #
    # shellcheck disable=SC2001,SC2016
    filtered_settings=$(sed -r 's/`(#\w{6,8})`/'\''\1'\''/g' <<< "${filtered_settings}")

    output_path="${gnome_path}/${output_filename}"
    echo -e "# ${settings_path}\n" > "$output_path"
    echo "$filtered_settings" >> "$output_path"
    echo -e "$settings_path\t$output_path"
}

save-settings /org/gnome/shell/extensions/ gnome.extensions.ini
save-settings /org/gnome/desktop/ gnome.desktop.ini
save-settings /org/gnome/settings-daemon/plugins/ gnome.plugins.ini
save-settings /org/gnome/ gnome.ini
