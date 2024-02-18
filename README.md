# My dotfiles

This repository contains my dotfiles.
This README contains information about how to recreate my environment.

## Setup so far (unfortunately, very likely to be an uncomplete list...)

The setup I've done so far. (And all I can remember at this point...)
Since a lot of the below configuration is already reflected in the config files in this repository,
there is no need to do all of these to recreate this environment.

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
    - `git config --user.name 'gen4ro'`
    - `git config --user.email '54658759+gen4ro@users.noreply.github.com'` # use provided noreply email address so mine stays hidden
  - set deafult branch name
    - `git config --global init.defaultBranch main`
  - setup remote repository
    - `git remote add origin git@github.com:gen4ro/nvim.git`
    - `git push -u origin main` # -u is short for --set-upstream which makes it remember so we only have to do "git push" or "git pull"
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
