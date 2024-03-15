# Personal Tidbits!

## Dotfiles

Which dotfiles are what, and which ones are necessary? Confusing...

- .zcompdump (Necessary)
  - Cache for zsh completion

## Neovim

### LSP

#### Even with installing typsecript eslint plugin and editing .eslintrc.json, eslint reports typescript as error

Removing eslint lsp and eslint_d linter from Mason which seems to only have very old (8y ago or so) versions
Installing manually and using lspconfig default options. --> seems fixed

After edit:
Actually it seems that eslint-lsp doesn't give diagnostics... Seems that is done by esling_d linter...
So by uninstalling eslint_d I obviously get no typescript errors no more...
For now let's jsut go with tsserver only which has diagnostics and other features of LSP

#### tsserver shows error for basic react stuff

https://github.com/vitejs/vite/issues/14011#issuecomment-1683630859

> change the "moduleResolution": "Node" in tsconfig.json

## GNU Stow

Automatically create symlinks to create "mirror" directories.

```
# Create symlinks for all files in ~/dotfiles under ~
~/dotfiles$ stow .

# Create symlinks, but if something already exists, move that to ~/dotfiles and replace
~/dotfiles$ stow --adopt .
```

## apt (Advanced Packaging Tool)

### apt-cache policy

Usage`apt-cache policy <package name>`

inspect local package configuration
ex) if multiple ppa have the same package name, see the prioritization

```
$ apt-cache policy neovim

neovim:
Installed: (none)
Candidate: 0.7.2-3~bpo22.04.1~ppa1
Version table:
0.7.2-3~bpo22.04.1~ppa1 500
500 https://ppa.launchpadcontent.net/neovim-ppa/stable/ubuntu jammy/main amd64 Packages
0.6.1-3 500
500 http://archive.ubuntu.com/ubuntu jammy/universe amd64 Packages
```

Here neovim was found in two repositories

## Git

### git config

Used for configuring git.
Can configure on three levels.

- System
- Global
- Local

```
git config --global user.name "My Name"
git config --global user.email "myemail@service.com"

# Set default editor for git
git config --global core.editor "nvim"

# Edit global settings with default editor
git config --global -e

# Carriage return setting. "true" for windows, "input" for linux/mac
# Not strictly necessary for linux/mac since we only have ln by default
git config --global core.autocrlf input
```

### git init

Initialize git repository.

## Tmux

Config file seems to only be `~/.config/tmux/tmux.conf`

### Plugins

In my case, they are located at `~/.config/tmux/plugins/`

- tpm: tmux plugin manager
- tmux-sensible: "A set of tmux options that should be acceptable to everyone."
- catppuccin/tmux: This does not have its own directory, but is installed in `~/.config/tmux/plugins/tmux/`

## Node.js

### nvm (Node Version Manager)

Install and manage multiple versions of node.js

Usage

```
nvm list  # list all versions
nvm install --lts  # install latest LTS version
nvm alias default 20.11.1  # Set default version
```
