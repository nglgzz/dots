# Dots

Here you can find most configuration files for my Linux environment.

## Project Structure

- [Fedora](./fedora/README.md) - Scripts to setup my configuration on a fresh
  install of Fedora.
- [Dots](./dots/README.md) – Configuration, scripts and aliases that are part of
  my environment.

The folders below are no longer in use, but I'm keeping them around for
future reference.

- [Ubuntu](./ubuntu/README.md) – Auto-install configuration and scripts to
  configure a fresh install of ubuntu.
- [Arch](./arch/README.md) – Scripts to install and configure Arch.

## Commands

- `make links` – Create symlinks for all configs. Where possible links
  are created from a directory rather than a file (eg. ~/.config/i3 instead of
  ~/.config/i3/config). **This command will overwrite existing configs**.
- `make load-gnome-settings` – Load gnome configuration from the [gnome](./gnome) directory.
- `make save-gnome-settings` – Save current gnome configuration into the [gnome](./gnome) directory.
- `make zsh-setup` - Install zsh extensions.
- `make vscode-setup` – Install all vscode extensions listed in
  [extensions.list](./dots/.config/Code/extensions.list)
- `make vim-setup` – Install nvim extensions listed in
  [init.vim](./dots/.config/nvim/init.vim)
- `make` – All of the above.
