declare -A shell=(
  # Commands
  [vim]=nvim
  [cat]=bat
  [_cat]='command cat'
  [e]='code .'
  [z]='zed .'
  [q]='exit'
  [l]='ls -ah --color=tty'
  [ll]='ls -lha --color=tty'
  [watch]='watch --color -n1'
  [tree]='tree -C'
  [treed]='tree -C -d -L 3'

  # Configs
  [zedit]='cd ~/dots && nvim $ZDOTDIR/.zshrc && source $ZDOTDIR/.zshrc && cd -'
  [ale]='cd $ZDOTDIR/aliases && nvim $(fzf) && source $ZDOTDIR/.zshrc && cd -'
  [zource]='source $ZDOTDIR/.zshrc'
  [i3edit]='nvim $XDG_CONFIG_HOME/i3/config'
  [codex]='code --list-extensions'

  # Navigation
  [b]='popd'
  [tmp]='cd ~/Downloads'
  [syn]='cd ~/Synced'
  [dots]='cd ~/dots'
  [..]='cd ..'
  [...]='cd ../..'
  [....]='cd ../../..'
  [.....]='cd ../../../..'

  # Utils
  [copy]='wl-copy'
  [paste]='wl-paste'
  [serve]='python3 -m http.server'
  [freeport]=free_port
  [randomword]='sort -R /usr/share/dict/words | head -1'
)

function free_port() {
  local pid=$(netstat -ltnp | grep ':'"$1" | awk '{print $7}' | sed 's|/.*||')
  kill "$pid" 2>/dev/null || true
}

function tousb() {
  sudo dd bs=4M if="$1" of="$2" status=progress
}

function cheat() {
  curl "cheat.sh/$1"
}

# Mount LUKS encrypted device
function emount() {
  sudo cryptsetup open "/dev/$1" "crypt_$1"
  sudo mount "/dev/mapper/crypt_$1" "$2"
}

# Unmount LUKS encrypted device
function eumount() {
  sudo umount "$2"
  sudo cryptsetup close "crypt_$1"
}

function mon-pretty() {
  # Currently ignores number of frame descriptors for
  # isochronous transfers.
  #
  # https://docs.kernel.org/usb/usbmon.html
  cat "$1" | jq -nR '[
      inputs |
      split(" ") |
      {
        "urb_id": .[0],
        "timestamp": .[1],
        "event_type": .[2],
        "address": .[3],
        "status": .[4],
        "rest": .[5:]
      }
    ]' | jq 'map(. | if .event_type == "S" then
      .event_type = "Submission"
    else
      if .event_type == "C" then
        .event_type = "Callback"
      else
        if .event_type == "E" then
          .event_type = "Submission error"
        end
      end
    end)' | jq 'map(. | if .status == "s" then
      .setup_packet = .rest[0:5] |
      .rest = .rest[5:] |
      .status = "setup"
    end)' | jq 'map(. | if .setup_packet then
      .setup_packet = {
        bmRequestType: .setup_packet[0],
        bRequest: .setup_packet[1],
        wValue: .setup_packet[2],
        wIndex: .setup_packet[3],
        wLength: .setup_packet[4],
      }
    end)' | jq 'map(. |
      .data_length = .rest[0] |
      .data_present = if .rest[1] == "=" then true else false end |
      if (.rest | length) > 2 then
        .data = .rest[2:]
      end |
      del(.rest)
    )'
}

function mon-control() {
  mon-pretty "$1" | jq 'map(select(.address | startswith("Ci")))'
}

# Captures USB traffic from the specified bus into the provided
# output file. More information here on enabling the usbmon module
#
# https://docs.kernel.org/usb/usbmon.html
#
# Requires disabling secure boot to be able to disable the
# kernel_lockdown preventing from logging traces from usbmon. More
# info here:
#
# man kernel_lockdown.7
#
# Example usage:
#   mon-capture 3 bus3.mon
function mon-capture() {
  sudo cat "/sys/kernel/debug/usb/usbmon/$1u" >"${2:-$1.mon}" || echo "Done capturing"
  sudo chown "${USER}" "${2:-$1.mon}"
}

function mon-log() {
  # Currently ignores number of frame descriptors for
  # isochronous transfers.
  #
  # https://docs.kernel.org/usb/usbmon.html

  sudo cat "/sys/kernel/debug/usb/usbmon/$1u" | jq -nR '
      inputs |
      split(" ") |
      {
        "urb_id": .[0],
        "timestamp": .[1],
        "event_type": .[2],
        "address": .[3],
        "status": .[4],
        "rest": .[5:]
      }
    ' | jq -S 'if .event_type == "S" then
      .event_type = "Submission"
    else
      if .event_type == "C" then
        .event_type = "Callback"
      else
        if .event_type == "E" then
          .event_type = "Submission error"
        end
      end
    end' | jq 'if .status == "s" then
      .setup_packet = .rest[0:5] |
      .rest = .rest[5:] |
      .status = "setup"
    end' | jq ' if .setup_packet then
      .setup_packet = {
        bmRequestType: .setup_packet[0],
        bRequest: .setup_packet[1],
        wValue: .setup_packet[2],
        wIndex: .setup_packet[3],
        wLength: .setup_packet[4],
      }
    end' | jq '
      .data_length = .rest[0] |
      .data_present = if .rest[1] == "=" then true else false end |
      if (.rest | length) > 2 then
        .data = .rest[2:]
      end |
      del(.rest)
    ' | jq 'if .status == "-75" then
        .status = "-75 (-EOVERFLOW)"
      else
        if .status == "-32" then
          .status = "-32 (-EPIPE)"
        else
          if .status == "-71" then
            .status = "-71 (-EPROTO)"
          else
            if .status == "-110" then
              .status = "-110 (-ETIMEDOUT)"
            else
              if .status == "-2" then
                .status = "-2 (-ENOENT)"
              end
            end
          end
        end
      end
    '
    # To find out more error codes:
    #   cat /usr/include/asm-generic/errno.h
}

# Usage:
#   mon-int bus address (or start of address)
mon-int() {
  mon-log "$1" | jq 'select(.address | contains("Ii:'"$1"':'"$2"'"))'
}

# Usage:
#   mon-dev bus address (or start of address)
mon-dev() {
  mon-log "$1" | jq 'select(.address | contains(":'"$1"':'"$2"'"))'
}

dmesg-usb() {
  sudo dmesg --notime -wd | grep --color=always usb
}
