#!/bin/bash -eu

# shellcheck source=/dev/null
source "$(dirname "$0")/install_packages.sh"

# Change default shell
default_shell=$(getent passwd "$LOGNAME" | cut -d: -f7)
if [[ "$default_shell" != "/usr/bin/zsh" ]]; then
	chsh -s /usr/bin/zsh
	echo "Changed default shell to zsh"
fi

# Log into GitHub
if ! gh auth status; then
	gh auth login
fi

# Clone dots folder
if [[ ! -d "$HOME/dots" ]]; then
	gh repo clone nglgzz/dots
fi

# Install zed editor
if ! which zed &>/dev/null; then
	curl -f https://zed.dev/install.sh | sh
fi

make -C "$HOME"/dots \
	links \
	zsh-setup \
	vim-setup \
	load-gnome-settings \
	install-gnome-extensions
