#!/bin/bash -e
# shellcheck disable=2068,2086

declare -A group_descriptions=(
	[home]="Social, gaming, bottles"
	[cloud]="Docker, Golang"
	[embedded]="Embedded development tools"

	[_distrobox]="Distrobox"
)

declare -A dnf_packages=(
	[base]="
        make zsh neovim bat fzf yq btop
        newt shfmt
        gh git-delta
        source-foundry-hack-fonts
        gnome-tweaks gnome-extensions-app
		fuse fuse-libs
    "
	[home]=""
	[cloud]="golang docker-cli docker-compose"
	[embedded]="
		kicad
		arm-none-eabi-gcc-cs arm-none-eabi-newlib
		cmake clang20 clang-tools-extra
		gdb openocd
		wireshark
	"

	[_distrobox]="distrobox"
)

declare -A flatpak_packages=(
	# flatseal - flatpak configuration
	# gearlever - appimage manager
	[base]="
        com.brave.Browser
		com.github.tchx84.Flatseal
		org.videolan.VLC
		org.onlyoffice.desktopeditors
		it.mijorus.gearlever
    "
	[home]="
        com.valvesoftware.Steam
		org.telegram.desktop
		com.synology.SynologyDrive
		com.discordapp.Discord
		md.obsidian.Obsidian
		com.usebottles.bottles
    "
	[cloud]="io.podman_desktop.PodmanDesktop"
	[embedded]="com.prusa3d.PrusaSlicer"

	# distroshelf - frontend for distrobox
	[_distrobox]="com.ranfdev.DistroShelf"
)

sudo dnf --assumeyes --quiet install ${dnf_packages["base"]}
flatpak install --assumeyes ${flatpak_packages["base"]}

# Build options string with a description of each category.
options=()
for key in "${!group_descriptions[@]}"; do
	if [[ $key != "base" ]]; then
		options+=("$key" "${group_descriptions[$key]}" OFF)
	fi
done

TERM=ansi
choices=$(
	whiptail \
		--title "Install extra packages" \
		--checklist "Select extra packages to install:" \
		20 78 10 \
		"${options[@]}" \
		3>&1 1>&2 2>&3
)
clear

# Remove quotes from whiptail output.
choices=$(echo "$choices" | tr -d '"')

for choice in $choices; do
	if [[ ${dnf_packages["$choice"]} != "" ]]; then
		if [[ ($REMOVE_PACKAGES == "yes" || $REMOVE_PACKAGES == "1") ]]; then
			sudo dnf --assumeyes --quiet remove ${dnf_packages["$choice"]}
		else
			sudo dnf --assumeyes --quiet install ${dnf_packages["$choice"]}
		fi
	fi

	if [[ ${flatpak_packages["$choice"]} != "" ]]; then
		if [[ ($REMOVE_PACKAGES == "yes" || $REMOVE_PACKAGES == "1") ]]; then
			flatpak uninstall --assumeyes ${flatpak_packages["$choice"]}
		else
			flatpak install --assumeyes ${flatpak_packages["$choice"]}
		fi
	fi
done
