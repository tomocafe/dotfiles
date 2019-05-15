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
* `perl` (5.x)

For i3wm:
* `i3`
* `i3blocks`
* `xrdb`, `xprop`, `xset`, `xsetroot`
* `rxvt-unicode` (`urxvt`)

## Themes

#### `gruvbox-dark`
![#282828](https://placehold.it/15/282828/000000?text=+)![#3c3836](https://placehold.it/15/3c3836/000000?text=+)![#cc241d](https://placehold.it/15/cc241d/000000?text=+)![#98971a](https://placehold.it/15/98971a/000000?text=+)![#d79921](https://placehold.it/15/d79921/000000?text=+)![#458588](https://placehold.it/15/458588/000000?text=+)![#b16286](https://placehold.it/15/b16286/000000?text=+)![#689d6a](https://placehold.it/15/689d6a/000000?text=+)![#a89984](https://placehold.it/15/a89984/000000?text=+)
![#a89984](https://placehold.it/15/a89984/000000?text=+)![#7c6f64](https://placehold.it/15/7c6f64/000000?text=+)![#fb4934](https://placehold.it/15/fb4934/000000?text=+)![#b8bb26](https://placehold.it/15/b8bb26/000000?text=+)![#fabd2f](https://placehold.it/15/fabd2f/000000?text=+)![#83a598](https://placehold.it/15/83a598/000000?text=+)![#d3869b](https://placehold.it/15/d3869b/000000?text=+)![#8ec07c](https://placehold.it/15/8ec07c/000000?text=+)![#ebdbb2](https://placehold.it/15/ebdbb2/000000?text=+)
#### `solarized-dark`
![#002b36](https://placehold.it/15/002b36/000000?text=+)![#073642](https://placehold.it/15/073642/000000?text=+)![#dc322f](https://placehold.it/15/dc322f/000000?text=+)![#859900](https://placehold.it/15/859900/000000?text=+)![#b58900](https://placehold.it/15/b58900/000000?text=+)![#268bd2](https://placehold.it/15/268bd2/000000?text=+)![#d33682](https://placehold.it/15/d33682/000000?text=+)![#2aa198](https://placehold.it/15/2aa198/000000?text=+)![#eee8d5](https://placehold.it/15/eee8d5/000000?text=+)
![#839496](https://placehold.it/15/839496/000000?text=+)![#002b36](https://placehold.it/15/002b36/000000?text=+)![#cb4b16](https://placehold.it/15/cb4b16/000000?text=+)![#586e75](https://placehold.it/15/586e75/000000?text=+)![#657b83](https://placehold.it/15/657b83/000000?text=+)![#839496](https://placehold.it/15/839496/000000?text=+)![#6c71c4](https://placehold.it/15/6c71c4/000000?text=+)![#93a1a1](https://placehold.it/15/93a1a1/000000?text=+)![#fdf6e3](https://placehold.it/15/fdf6e3/000000?text=+)
#### `solarized-light`
![#fdf6e3](https://placehold.it/15/fdf6e3/000000?text=+)![#073642](https://placehold.it/15/073642/000000?text=+)![#dc322f](https://placehold.it/15/dc322f/000000?text=+)![#859900](https://placehold.it/15/859900/000000?text=+)![#b58900](https://placehold.it/15/b58900/000000?text=+)![#268bd2](https://placehold.it/15/268bd2/000000?text=+)![#d33682](https://placehold.it/15/d33682/000000?text=+)![#2aa198](https://placehold.it/15/2aa198/000000?text=+)![#eee8d5](https://placehold.it/15/eee8d5/000000?text=+)
![#657b83](https://placehold.it/15/657b83/000000?text=+)![#002b36](https://placehold.it/15/002b36/000000?text=+)![#cb4b16](https://placehold.it/15/cb4b16/000000?text=+)![#586e75](https://placehold.it/15/586e75/000000?text=+)![#657b83](https://placehold.it/15/657b83/000000?text=+)![#839496](https://placehold.it/15/839496/000000?text=+)![#6c71c4](https://placehold.it/15/6c71c4/000000?text=+)![#93a1a1](https://placehold.it/15/93a1a1/000000?text=+)![#fdf6e3](https://placehold.it/15/fdf6e3/000000?text=+)

---

## bash

The file `.bash_settings` includes common aliases, settings, and functions and should be sourced from the user's `.bashrc` or `.bash_profile` on the system. The `.bashrc` file is not included in this repository since it may need to be vastly different depending on the system; hence, everything deemed common enough is moved into the `.bash_settings` file. The `.bash_functions` file defines helpful functions and is included by the `.bash_settings` script.

### Features

* Full-line prompt with git/Perforce status, background job count, last command status, and right-justified current working directory (with truncation)
    * Hostname colored differently if root process is a connection daemon, warning that closing the shell may close a connection
* (Optional) fast, basic prompt
* Sets `$LS_COLORS`
* Handy commands:
    * `dc` (backwards `cd`) with tab completion to go up the directory tree to a desired directory
    * `mcd` (make and change to directory)
    * `hc` (hard copy) replaces symbolic links with copies of the source files/directories
    * `compress` and `extract` to work generically with archive files
* Helper functions:
    * `_join` joins the arguments with a given delimiter
    * Pretty status messages: `_putError`, `_putWarning`, `_putInfo`
    * Path manipulation: `_{in,prepend,prependUnique,append,appendUnique,removeFrom,swapIn}{Path,LdLibraryPath,LdPreloadPath,CdPath}`
    * Check lists of files/commands/variables: `_check{Set,Command,Readable,Writeable,Executable,Exists,Directory,Link}`
    * `_showColors` shows 16-color palette in detail and also show all supported terminal colors

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
# Following needed only if i3 is installed in a non-standard location, e.g. ~/i3wm-el6/i3-4.8
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

## search

The script `search` will invoke `ack`, passing through all arguments, and return the matches in a base-36-indexed paged list. The companion command `search-select` allows you to select a match by its index and perform an arbitrary action, by default it opens `$EDITOR` on the matched file at the matching line number. Issuing `search-select` with no argument recalls all the match results. The last 10 searches are cached; you can list the caches with `search-list-cache` and then prefix any invocation of `search-select` with the argument `+<cache ID>` to draw from a different cache than the default (1). Searching with `ag` is supported by using `search-ag` instead of `search-ack` or just `search`. To perform an arbitrary non-default action on the selection using `search-select`, append the command as the last argument using `{file}` as a placeholder for the match's file path and {line} as the match's line number, or alternatively, the first occurrence of `{}` will receive the file path and the second will receive the line number.

The `bash` settings in this environment alias `search` to `s`, `search-select` to `a`, and `search-list-cache` to `sls`.

