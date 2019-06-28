# Config Files/Scripts
Some of my configuration files that I use to sync across my machines.

GNU Stow used to handle the symlinks.

Within dotfiles, use stow command to create symlink. Stow will not rewrite the file if it already exists prior to being stowed. stow -D to unstow.

Example usage to create symlink:
```
stow vim
```

### Gitignore
Basic gitignore taken from Github Help.
File stored in default? location: ~/.config/git/ignore

### Brew (for MacOS)
Run brew bundle to execute Brewfile.

### Vim
Most vim config located in .vimrc
Plugins handled by vim-plug. It should be automatically installed after activating (n)vim for the first time.
A full restart of (n)vim after installing plugins is necessary for full functionality.
Examples: Themes and coc-highlight

Neovim is used heavily; some things may break without the nightly version of neovim!

### Themes
You'll need to manually configure themes as necessary.

To install terminal themes:
https://github.com/Mayccoll/Gogh

### Ignore
An ignore file used by fzf and rg. May be aggressive and result in false positives.
Drastically reduces pool of options for fzf/rg to scan from (for my machines anyways).

### bash_profile
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
Mostly key mappings (needs xcape package). Unable to stow for now bc it accesses files which requires root privilege. Manually copy / paste into respective files. Autosourcing .Xmodmap doesn't seem to work with Ubuntu 18.04.

Maps Caps Lock to ISO_SHIFT_LEVEL_3, a fake key used as extra modifier.
hjkl with iso key gives arrow key functionality; vim-like.
xcape gives the caps lock key two functions: if pressed quickly, it sends escape key. When held it acts like iso shift key.

### TODO:

- Create install script for everything.
- Less dependent on Homebrew? Linux-focused?
- More install instructions.
