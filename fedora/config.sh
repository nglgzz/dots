#!/bin/bash -eu

# shellcheck source=/dev/null
source "$(dirname "$0")/packages.sh"

# Need to run this here in case `dialog` or other dependencies of this script
# are not installed.
install_base_packages

function initial_setup() {
	# Install packages
	choices=$(choose_groups "Select packages to install (space to select)")
	for choice in $choices; do install_group "$choice"; done

	# Change default shell
	default_shell=$(getent passwd "$LOGNAME" | cut -d: -f7)
	if [[ "$default_shell" != "/usr/bin/zsh" ]]; then
		chsh -s /usr/bin/zsh
		echo "Changed default shell to zsh"
	fi

	# Log into GitHub and update dots remote
	if dialog --erase-on-exit --yesno "Login into GitHub?" 6 50; then
		gh auth login
		git -C "$HOME/dots" remote set-url git@github.com:nglgzz/dots.git
	fi

	# Link config files
	make -C "$HOME/dots" \
		links \
		zsh-setup \
		vim-setup

	if dialog --erase-on-exit --yesno "Install VSCode extensions?" 6 50; then
		make -C "$HOME/dots" vscode-setup
	fi

	if dialog --erase-on-exit --yesno "Restore GNOME configuration?" 6 50; then
		make -C "$HOME/dots" \
			load-gnome-settings \
			install-gnome-extensions
	fi
}

function main_menu() {
	dialog \
		--erase-on-exit \
		--cancel-label "Exit" \
		--menu "Select an option" 15 60 8 \
		"1" "Initial setup" \
		"2" "Install packages" \
		"3" "Remove packages" \
		"4" "Restore GNOME configuration" \
		"5" "Save GNOME configuration" \
		3>&1 1>&2 2>&3
}

choice=$(main_menu)
case $choice in
1)
	initial_setup
	;;
2)
	# Install packages
	choices=$(choose_groups "Select packages to install (space to select)")
	for choice in $choices; do install_group "$choice"; done
	;;
3)
	# Remove packages
	choices=$(choose_groups "Select packages to remove (space to select)")
	for choice in $choices; do uninstall_group "$choice"; done
	;;
4)
	# Restore GNOME configuration
	echo "Restoring GNOME configuration"
	make -C "$HOME"/dots load-gnome-settings
	;;

5)
	# Save GNOME configuration
	echo "Saving GNOME configuration"
	make -C "$HOME"/dots save-gnome-settings
	;;
esac
