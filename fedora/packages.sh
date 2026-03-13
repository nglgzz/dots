#!/bin/bash -e

packages_yml="$(dirname "$0")/packages.yml"

function install_base_packages() {
	sudo dnf --assumeyes install \
		make zsh neovim bat fzf yq btop \
		dialog shfmt \
		gh git-delta \
		source-foundry-hack-fonts \
		gnome-tweaks gnome-extensions-app \
		fuse fuse-libs

	flatpak install --assumeyes \
		com.brave.Browser \
		com.github.tchx84.Flatseal \
		org.videolan.VLC \
		org.onlyoffice.desktopeditors \
		it.mijorus.gearlever
}

function get_group() {
	yq ".groups[\"$1\"].$2" "$packages_yml"
}

function choose_groups() {
	package_groups=$(
		yq '.groups | keys | .[]' "$packages_yml"
	)

	# Build options string with a description of each package group.
	options=()
	for key in $package_groups; do
		description=$(get_group "$key" "description")
		options+=("$key" "$description" off)
	done

	dialog \
		--erase-on-exit \
		--title "Package groups" \
		--checklist "$1" 15 75 10 \
		"${options[@]}" \
		3>&1 1>&2 2>&3
}

function install_group() {
	dnf_packages=$(get_group "$1" "dnf[]")
	flatpak_packages=$(get_group "$1" "flatpak[]")
	extras_packages=$(get_group "$1" "extras[]")

	if [[ "$dnf_packages" != "" ]]; then
		# shellcheck disable=2068,2086
		sudo dnf --assumeyes install $dnf_packages
	fi

	if [[ "$flatpak_packages" != "" ]]; then
		# shellcheck disable=2068,2086
		flatpak install --assumeyes $flatpak_packages
	fi

	if [[ "$extras_packages" != "" ]]; then
		for extra in $extras_packages; do
			install_file="$(dirname "$0")/extras/$extra/install.sh"
			if [[ -f "$install_file" ]]; then
				echo "installing extra package: $extra"
				"$install_file"
			else
				dialog --erase-on-exit --ok-label Continue \
					--msgbox "Could not find install file for \"$extra\"." 6 60
			fi
		done
	fi
}

function uninstall_group() {
	dnf_packages=$(get_group "$1" "dnf[]")
	flatpak_packages=$(get_group "$1" "flatpak[]")
	extras_packages=$(get_group "$1" "extras[]")

	if [[ "$dnf_packages" != "" ]]; then
		# shellcheck disable=2068,2086
		sudo dnf --assumeyes remove $dnf_packages
	fi

	if [[ "$flatpak_packages" != "" ]]; then
		# The command fails if the packages don't exist
		# shellcheck disable=2068,2086
		flatpak uninstall --assumeyes $flatpak_packages || true
	fi

	if [[ "$extras_packages" != "" ]]; then
		for extra in $extras_packages; do
			install_file="$(dirname "$0")/extras/$extra/uninstall.sh"
			if [[ -f "$install_file" ]]; then
				echo "Uninstalling extra package: $extra"
				"$install_file"
			else
				dialog --erase-on-exit --ok-label Continue \
					--msgbox "Could not find uninstall file for \"$extra\"." 6 60
			fi
		done
	fi
}
