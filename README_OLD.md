# My dotfiles

This repository contains my dotfiles.

This README contains information about how to recreate my environment (WSL2 Ubuntu 22).

I'm using GNU stow to automatically create symlinks to my dotfiles which are placed under "~/dotfiles/" (this directory corresponds to this repo).
By executing `make` in this directory, all symlinks are created / updated.

## Required setup

Manual setup required, likely to be incomplete...

Many of the below configuration is already reflected in the config files in this repository,
so not all are necessary.

- trash-cli
  - install this so rm doesn't fully remove right away
  - ref: https://github.com/andreafrancia/trash-cli
- zsh
  - install zsh
  - install nerdfont (JetBrainMono)
  - install ohmyzsh
  - install powerlevel10k
  - use lazyload for plugins (nvm was slowing me down a lot..)
  - https://lakur.tech/2021/12/10/fix-slow-zsh-startup-nvm/
  - Setting up autocomplete --> https://gist.github.com/n1snt/454b879b8f0b7995740ae04c5fb5b7df
- javascript
  - install nvm [https://github.com/nvm-sh/nvm]
  - install node.js with nvm
    - `nvm install node`
  - npm will be installed with node
- install neovim
  - install from source using tarball
  - installing all plugins with lazy.nvim etc.
  - lsp
    - installing gcc with "sudo apt install build-essential"
    - install unzip for clangd with `sudo apt install unzip`
- git
  - create ssh keypair and register for the github account
    - `ssh-keygen -t ed25519`
  - setup email and username
    - `git config --user.name 'lugen4ro'`
    - `git config --user.email '54658759+lugen4ro@users.noreply.github.com'` # use provided noreply email address so mine stays hidden
  - set deafult branch name
    - `git config --global init.defaultBranch main`
  - setup remote repository
    - `git remote add origin git@github.com:lugen4ro/nvim.git`
    - `git push -u origin main` # -u is short for --set-upstream which makes it remember so we only have to do "git push" or "git pull"
  - Install gitkraken on WSL2 --> https://www.gitkraken.com/blog/wsl2-and-gitkraken-client#download-install
- tmux
  - came already installed
  - install tpm (tmux plugin manager)
  - install vim-tmux-navigator
  - install catppuccin/tmux for nice look
- fzf
- cppman to view the cpp manual. Also get a vim plugin that allows viewing the manual in vim
  - also you have to update the registry when installing with apt it seems
  - https://www.reddit.com/r/cpp_questions/comments/10fhxd1/how_can_i_view_the_documentation_of_c_in_the/
- powerline
  - https://www.ricalo.com/blog/install-powerline-windows/#install-and-configure-powerline-fonts
- backup of WSL
  - https://medium.com/codex/setting-up-regular-automatic-backup-of-your-windows-subsystem-for-linux-wsl2-data-using-task-b36d2b2519dd
- install clang for C++23
  - https://ubuntuhandbook.org/index.php/2023/09/how-to-install-clang-17-or-16-in-ubuntu-22-04-20-04/
- Install deno
- Install Docker
  - https://docs.docker.com/engine/install/ubuntu/
