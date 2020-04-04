## Formatting
bold=$(tput bold)
normal=$(tput sgr0)

## RAM size in GB
ram=$(grep MemTotal /proc/meminfo | awk '{print $2}')
ram=$(expr $ram / 1000 / 1000)
swap_size=$(expr $ram \* 2)G

## Helpers
function read_confirm() {
  while true; do
    read -p "${bold}Enter $1:${normal} " value
    read -p "Entered ${bold}${value}${normal}, continue?[y/N] " -r
    echo -e "\n"

    if [[ $REPLY =~ ^[Yy]$ ]]; then
      break
    fi
  done

  local __resultvar=$1
  eval $__resultvar="'${value}'"
}

## Device
while true; do
  clear
  fdisk -l
  echo -e "\n"
  read -p "${bold}Choose a device to install the system on (eg. sdb):${normal} " device

  # Check if device exists, show details of the
  # selected device, and ask for confirmation.
  device=/dev/$device

  if [[ -b $device ]]; then
    clear
    fdisk -l $device
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
