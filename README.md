# Dots

Here you can find most configuration files for my Arch environment.

## Project Structure

- [Arch](./arch/README.md) – Scripts to install this setup from scratch (also
  contains a list of dependencies needed for this setup).

- [Dots](./dots/README.md) – Configuration, themes, and scripts that are part of
  my environment.

## Commands

- `make links` – Create symlinks for all configs. Where possible links
  are created from a directory rather than a file (eg. ~/.config/i3 instead of
  ~/.config/i3/config). **This command will overwrite existing configs**.
- `make install-deps` – Install all dependencies found on
  [pacman.list](./arch/pacman.list) and [aur.list](./arch/aur.list). Works on
  Arch only and assumes pacaur is installed.
- `make vscode-setup` – Install all vscode extensions listed in
  [extensions.list](./dots/.config/Code/extensions.list)
- `make vim-setup` – Install nvim extensions listed in
  [init.vim](./dots/.config/nvim/init.vim)
- `make` – All of the above.

## Pics

**Clean**

![Screenfetch](https://i.imgur.com/zSE9tTU.png)

**Dirty**

![VS Code + Termite](https://i.imgur.com/OmDdP2X.png)

## Notes

- Workspaces 2 and 3 are bound to my primary screen, while 1, 5 6 are bound
  to my secondary screen (if connected).

**Workspace bindings**

- **workspace 2**: VS Code
- **workspace 3**: Termite
