# Config Files/Scripts

Some of my configuration files that I use to sync across my machines.

GNU Stow used to handle the symlinks.

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

### Vim

Most vim config located in .vimrc Plugins handled by vim-plug. It should be
automatically installed after activating (n)vim for the first time. A full
restart of (n)vim after installing plugins is necessary for full functionality.
Examples: Themes and coc-highlight

Neovim is used heavily; some things may break without the nightly version of
neovim!

### Themes

You'll need to manually configure themes as necessary.

To install terminal themes:
https://github.com/Mayccoll/Gogh

### Ignore

An ignore file used by fzf and rg. May be aggressive and result in false
positives. Drastically reduces pool of options for fzf/rg to scan from (for my
use cases anyways).

### bash

```
source ~/.bash_profile
```

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

#### For i3:

- fonts-font-awesome
- i3blocks
- rofi
- yad
- bluetooth applet (not exact name)
- i3-gnome
  - https://github.com/jcstr/i3-gnome
- xsecurelock (lock; listens to dpms. follow the readme heavily)
- xfce4-power-manager (control sleep / suspend)

#### optional:

- nm-applet (network manager gui)
- gnome-tweaks
- tlp (power savings; thinkpad requires extra steps)
- autorandr (multiple display support)
  - https://github.com/phillipberndt/autorandr (do not use pip; build from source)

### NOTES/TIPS:

- systemd stuff requires absolute paths
- xcape lags with Gnome (0.5 second delay)
- echo $DISPLAY and $XAUTHORITY to get right one.
- xev to record input.
- xrandr for manual screen.
- udev for listening to udev/kernel changes (like hotplugging).
  - can't get some programs to run fully.
  - the script is being called (tested by redirecting output to a tmp file),
    but the actual action that I want is not being executed.
  - absolute paths must be used.

### TODO:

- Create install script for everything.
- Less dependent on Homebrew? Linux-focused?
- More install instructions.

### NOT WORKING

- Manual invocation lags bc of nm (network-manager) supposedly.
  - If nm is force closed, then there's no lag but have to manually turn on.
- Keyboard hotplugging (to call script)
