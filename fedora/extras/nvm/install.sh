#!/bin/bash -ex

latest_version=$(
	curl https://github.com/nvm-sh/nvm/releases/latest --silent --show-headers |
		grep location |
		sed 's|.*/||' |
		tr -d '\r\n'
)

export XDG_CONFIG_HOME="$HOME/.config"
export PROFILE=/dev/null

curl -f "https://raw.githubusercontent.com/nvm-sh/nvm/$latest_version/install.sh" | bash
