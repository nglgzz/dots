declare -A bluetoothctl=(
  ['bt']='bluetoothctl'
  ['bt-connect']='bluetoothctl connect $(bluetoothctl devices | fzf | awk '\''{print $2}'\'')'
  ['bt-disconnect']='bluetoothctl disconnect $(bluetoothctl devices | fzf | awk '\''{print $2}'\'')'
  ['bt-restart']='sudo rmmod btusb && sudo modprobe btusb'
)

# Connect to device sharing an internet connection via bluetooth
function bt-share() {
  # Get bluetooth device MAC address
  device=$(bluetoothctl devices | fzf | awk '{print $2}')
  device_path="/org/bluez/hci0/dev_$(echo $device | sed 's/:/_/g')"

  # Create bnep0 network interface
  dbus-send --system --type=method_call --dest=org.bluez $device_path org.bluez.Network1.Connect string:'nap'

  # Connect to new interface
  sudo dhcpcd bnep0
}
