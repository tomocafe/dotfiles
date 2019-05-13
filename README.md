# dotfiles

Common settings and scripts to bring up a system for comfortable use. Includes setup files for [i3wm](https://i3wm.org), [bash](https://www.gnu.org/software/bash), [vim](https://www.vim.org). and more.

## Getting Started

Clone the repository to your home directory, enter the `dotfiles` folder, and run the `bootstrap` script.

If there are any missing commands that these dotfiles rely on, the `bootstrap` script will issue a warning prompting you to install them on the system.

## Logistics

These dotfiles are organized into modules that can be individually installed using [`stow`](https://www.gnu.org/software/stow). `stow` will install files one directory above as symbolic links, merging the directory structure with any existing one.

To install the `bash` module:

```shell
cd ~/dotfiles
stow bash
```

## Dependencies

* `stow`
* `m4`
* `bash` (4.1+)
* `python3`

For i3wm:
* `i3`
* `i3blocks`
* `xrdb`, `xprop`, `xset`, `xsetroot`

## Themes

* `gruvbox-dark`
* `solarized-dark`
* `solarized-light`

---

## bash

The file `.bash_settings` includes common aliases, settings, and functions and should be sourced from the user's `.bashrc` or `.bash_profile` on the system. The `.bashrc` file is not included in this repository since it may need to be vastly different depending on the system; hence, everything deemed common enough is moved into the `.bash_settings` file. The `.bash_functions` file defines helpful functions and is included by the `.bash_settings` script.

## i3wm

The configuration of `i3` is managed by `m4` to generate configuration files based on a selected theme. To set up `i3` for first use, using the `gruvbox-dark` theme as an example:

```
cd ~/.i3
m4 -Ithemes/gruvbox-dark Xresources.m4 > Xresources
m4 -Ithemes/gruvbox-dark config.m4 > config
```

If the system has an old version of `i3` without `pango` support, add the `-DM4_I3_COMPAT` flag to `m4`.

The `i3` configuration relies on scripts supplied under `$I3_HOME/bin`, where `$I3_HOME` is the directory where the configuration is stored, usually `~/.i3`. Either the environment variable `$I3_HOME` must be set accordingly _before_ launching `i3`, or the configuration must be stored at the default location of `~/.i3` for the configuration to find these scripts.

### i3blocks

You will need to create an `i3blocks` configuration file at `$I3_HOME/i3blocks.conf`. It is not checked in since it is commonly written differently for each system, based on differing needs. See the [`i3blocks` documentation](https://github.com/vivien/i3blocks) for instructions on how to write the configuration file.

A minimal example:

```
[time]
command=date
interval=5
```

### Other features

* <kbd>Mod</kbd>+<kbd>Shift</kbd>+<kbd>T</kbd> brings up a `dmenu` to select and apply a theme (including `vim`)
* <kbd>Mod</kbd>+<kbd>X</kbd> brings up a `dmenu` to launch a terminal and connect via `ssh` to a selected server (from the known hosts on the system)
* <kbd>Mod</kbd>+<kbd>Shift</kbd>+<kbd>Q</kbd> checks if the window being killed has a connection daemon as a root process (e.g. `sshd`) and enters `close-mode` to confirm killing the window by pressing <kbd>Y</kbd> to avoid accidentally closing a session
* `blocklet` is a script to generate `i3blocks` blocklets for weather, traffic, stock ticker, system stats, etc.

### xsession

If you are not launching `i3` from a login manager, you may need to create an `~/.xsession` file.

An example xsession file to launch `i3`:

```shell
# Use local fonts for X11
xset +fp $HOME/.fonts
xset fp rehash

# Set up environment to run i3wm
export I3_HOME=~/.i3
# Following needed only if i3 is installed in a non-standard location
export PATH="${PATH:+$PATH:}${HOME}/i3wm-el6/i3-4.8/bin:${I3_HOME}/bin"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}${HOME}/i3wm-el6/i3-4.8/lib"
# Following needed only if i3 is an old version without pango support
export I3_M4_THEMEARGS="-DM4_I3_THEMEARGS"

# Start i3wm
exec i3 ${I3_HOME:+-c $I3_HOME/config} </dev/null
```

Modification of `$PATH` (and etc.) can be skipped if `i3` is installed system-wide.

## vim

This provides a basic `vimrc` configuration and provides theme support. To apply the theme `gruvbox-dark`, for example:

```shell
cd ~/.vim
m4 -Ithemes/gruvbox-dark theme.m4 > theme
```

If using `dmenu_theme` from `i3`, the `vim` theming will be handled automatically.

