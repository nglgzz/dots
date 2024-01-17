#!/bin/bash
# Variables set here are meant to be used by other scripts sourcing this file.
# shellcheck disable=SC2034

# Requires no variables.
# Sets the following variables.
declare swap_size # path to selected device
declare device    # twice the RAM size in GB
declare hostname  # user provided hostname
declare username  # user provided username

declare bold   # bold output formatting
declare normal # normal output formatting

## Formatting
bold=$(tput bold)
normal=$(tput sgr0)

## RAM size in GB
ram=$(grep MemTotal /proc/meminfo | awk '{print $2}')
ram=$(("$ram" / 1000 / 1000))
swap_size=$(("$ram" * 2))G

## Helpers
function read_confirm() {
  while true; do
    read -rp "${bold}Enter $1:${normal} " value
    read -rp "Entered ${bold}${value}${normal}, continue?[y/N] "
    echo -e "\n"

    if [[ $REPLY =~ ^[Yy]$ ]]; then
      break
    fi
  done

  local __resultvar=$1
  eval "$__resultvar"="'${value}'"
}

## Device
while true; do
  clear
  fdisk -l
  echo -e "\n"
  read -rp "${bold}Choose a device to install the system on (eg. sdb):${normal} " device

  # Check if device exists, show details of the
  # selected device, and ask for confirmation.
  device=/dev/$device

  if [[ -b $device ]]; then
    clear
    fdisk -l "$device"
    echo -e "\n${bold}Are you sure you want to overwrite this device?${normal}"

    select choice in "Yes" "No"; do
      case $choice in
      Yes) break ;;
      No) break ;;
      esac
    done

    # If device exists and user confirmed that wants to use
    # that device, then proceed.
    if [[ $choice == "Yes" ]]; then
      break
    fi
  fi
done

read_confirm hostname
read_confirm username

# Cleanup private variables
unset ram choice
