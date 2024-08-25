# dotfiles

- My personal dotfiles and steps to reproduce my enviornment
- Currently used with
  - Mac
  - WSL2 Ubuntu22

## Tools used for setup

- git
- [Task](https://taskfile.dev/)
  - To manage installation and cleaning up
- [Homebrew](https://brew.sh/)
  - To install packages
- [GNU Stow](https://www.gnu.org/software/stow/)
  - To create symlinks to centrally managed dotfiles

## Setup

1. Install brew

Install with the below command and follow the directives printed.

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. Install Task

```
brew install go-task/tap/go-task
```

3. Setup dotfiles with Task

```
git clone https://github.com/lugen4ro/dotfiles ~/.dotfiles && \
cd ~/.dotfiles && \
task setup
```

## How to make updates

- Always edit/create a file under .dotfiles
  - If you edit a file directly, it might be a file that is under a symlink directory making the changes not propagate to the git repo
  - If you create a new file, that file will not be managed by this git repo
- Then execute `task setup`

## How to delete

## To Do

- Research whether you can make stow create symlinks for all files, not making use of directory symlinks

Add some of the following to auto-install

```
$ brew list
==> Formulae
autoconf                gh                      libuv                   luv                     nodebrew                pyenv                   tmux                    unibilium
ca-certificates         gitmux                  libvterm                m4                      openssl@3               readline                tmux-mem-cpu-load       utf8proc
cmake                   go-task                 lpeg                    msgpack                 pcre2                   ripgrep                 tpm                     xz
fzf                     goenv                   lua                     ncurses                 pkg-config              stow                    tree                    zsh-autocomplete
gettext                 libevent                luajit                  neovim                  powerlevel10k           switchaudio-osx         tree-sitter

==> Casks
apptivate               google-chrome           keycastr                microsoft-auto-update   microsoft-office        notion                  slack                   temurin                 zoom
```
