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

![Clean](https://i.imgur.com/1JZ0CTK.png)

**Rofi**

![Rofi](https://i.imgur.com/7dxS8Xq.png)

**Screenfetch**

![Screenfetch](https://i.imgur.com/SQCw0Yl.png)

**Terminal + VS Code**

![Terminal + VS Code](https://i.imgur.com/I6LkSPl.png)
