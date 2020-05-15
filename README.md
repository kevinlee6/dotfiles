# Config Files/Scripts

Some of my configuration files that I use to sync across my machines.

GNU Stow used to handle the symlinks, which explains the directory structure.

Within dotfiles, use stow command to create symlink. Stow will not rewrite the
file if it already exists prior to being stowed. stow -D to unstow.

Example usage to create symlink:

```
stow vim
```

### Gitignore

Basic gitignore taken from Github Help.
File stored in default location: ~/.config/git/ignore

### Brew (for MacOS)

Run brew bundle to execute Brewfile.

### Utils

bat: colorized cat

### Vim

Most vim config located in .vimrc. Plugins handled by vim-plug. It should be
automatically installed after activating (n)vim for the first time. A full
restart of vim after installing plugins is necessary for full functionality.

There are 2 other vimrc files: one w/ nvim specific files and one with vim
specific files. They act mostly as a supplement, but the vimrc for original vim
may be required if original vim is used.

### Themes

You'll need to manually configure themes as necessary.
Config files such as alacritty (terminal) and vim should have theme-support
included (currently using a light scheme called PaperColor).

### Ignore

An ignore file used by fzf and rg. Drastically reduces pool of options for
fzf/rg to scan from (for my use cases anyways).

### Keyboard

qwerty_1.txt is used for Kinesis keyboard.

### bash

```
source ~/.bash_profile
```

bashrcs split into different files.

Important notes:

- Shell uses vi editor instead of default emacs; beware modal editing.

### tmux

TPM needed for certain plugins.

```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### linux

A lot of missing info due to trial/error and not documenting it.
Stackoverflow / Arch wiki should solve most problems.

Contains i3 and i3blocks; needs external packages to be installed.
Some i3blocks are edited; not all are needed.

List of external packages (not entire list):

#### For i3 (see the config file for all the details):

- i3blocks (for i3 statusbar)
- fonts-font-awesome (glyph support in the statusbar)
- rofi (program selector)
- yad (floating window)
- bluetooth applet (not exact name)
- i3-gnome
  - https://github.com/i3-gnome/i3-gnome
  - could use gnome-flashback; I found it introduced more overhead.
- xsecurelock (lock; listens to dpms. follow the readme heavily)
- xfce4-power-manager (control sleep / suspend)

#### optional:

- nm-applet (network manager gui)
- gnome-tweaks
- tlp (power savings; thinkpad requires extra steps. not sure if still needed)
- autorandr (multiple display support)
  - https://github.com/phillipberndt/autorandr

### NOTES/TIPS:

- systemd stuff requires absolute paths
- xcape lags with Gnome; known issue.
- echo $DISPLAY and $XAUTHORITY to get right one if needed.
- xev to record input.
- xrandr for manual screen.
- udev for listening to udev/kernel changes (like hotplugging).
  - can't get some programs to run fully.
  - the script is being called (tested by redirecting output to a tmp file),
    but the actual action that I want is not being executed.
  - absolute paths must be used.

### TODO:

- Create install script for everything.
- More install instructions.

### NOT WORKING

- Keyboard hotplugging (to call script), although I don't unplug keyboard often.
