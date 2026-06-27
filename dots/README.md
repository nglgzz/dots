# [Dots](../README.md) – Dots

## Files

- **.bin** – Scripts used by other configs. All executables in this directory
  are available on PATH. Scripts in **.bin/extra** are gitignored.
- **.config** – Configuration directories for most things that need to be
  configured.
- **.zshenv** – Entry point for ZSH configuration. The rest of the
  configuration is in **.config/zsh**.

## Zsh

Since my **.zshrc** file was becoming too big to comfortably navigate I split it
into more manageable chunks. Now there is a main file that imports the theme and
aliases.

Aliases are grouped by the programs they alias (with exception of shell and
keyboard). Alias files define most of their aliases through an associative
array, this is partially for readability, but also to make it possible to list
all aliases related to a program when running `aliases <command>`.
