# Config Files/Scripts
Some of my configuration files that I use to sync across my machines.

GNU Stow used to handle the symlinks.

Within dotfiles, use stow command to create symlink. Stow will not rewrite the file if it already exists prior to being stowed. stow -D to unstow.

Example usage to create symlink:
```
stow vim
```

### Gitignore
Useful for ignoring DS_Stores and tags from ctags. Basic gitignore taken from Github Help.
File stored in default? location: ~/.config/git/ignore

### Brew (for MacOS)
Run brew bundle to execute Brewfile.

### Vim
Some vim configuration requires plugins, handled by Vundle. Install script in .vim/bin/install.

To make install executable if not already, chmod +x the file within command line.

Example:

If untouched / default file paths, the command:
```
chmod +x ~/.vim/bin/install
```
should make it executable.

Then:
```
~/.vim/bin/install
```
should run the script to install vim plugins.

If access denied, you may need administrator privilege / sudo.

To update:
```
~/.vim/bin/update
```

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

### TODO:

- Create install script for everything.
- Less dependent on Homebrew? Linux-focused?
- More install instructions.
