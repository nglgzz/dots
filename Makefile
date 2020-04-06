SHELL=/usr/bin/zsh

# HOME_PATH should be empty as it's set by the link script.
HOME_SRC="$$HOME/dots/dots"
HOME_PATH=

CONFIG_PATH=.config/
CODE_PATH=${CONFIG_PATH}Code/User/

HOME_FILES=$(shell find ${HOME_SRC} -mindepth 1 -maxdepth 1)
CONFIG_FILES=$(shell find ${HOME_SRC}/${CONFIG_PATH} -mindepth 1 -maxdepth 1)
CODE_FILES=$(shell find ${HOME_SRC}/${CODE_PATH} -mindepth 1 -maxdepth 1)

all: links zsh-setup vscode-setup vim-setup

links: links-HOME links-CONFIG links-CODE

links-HOME links-CONFIG links-CODE: links-%:
	@echo -e "\n$$(tput bold)$* files linked$$(tput sgr0)"
	@$(foreach file, \
		$($*_FILES), \
		./link.sh "${$*_PATH}$$(basename $(file))"; \
	)

zsh-setup:
	mkdir -p ~/projects
	mkdir -p ~/.cache/zsh
	rm -rf ~/.config/zsh/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/zsh-autosuggestions

vscode-setup:
	@cat "${HOME_SRC}/${CODE_PATH}../extensions.list" | \
		xargs -L 1 code --force --install-extension

vim-setup:
	nvim +PlugInstall +qall

