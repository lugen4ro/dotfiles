# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
#
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# source colorscheme for zsh syntax highlighting (source before loadig the zsh-syntax-highlighting plugin)
source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh


# plugin: zsh-autocomplete
# source /opt/homebrew/Cellar/zsh-autocomplete/23.07.13/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"


# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
zstyle ':omz:plugins:nvm' lazy yes



# Oh my zsh plugins
# plugins=(git nvm)
# plugins=(git nvm zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)
# plugins=(git nvm zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting)
# plugins=(git nvm zsh-autosuggestions  fast-syntax-highlighting)
# plugins=(git nvm zsh-autosuggestions zsh-syntax-highlighting zsh-autocomplete)
plugins=(git nvm zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh


# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh



# ----------------------------------- gen4ro ----------------------------------- #

# For neovim, setting IME with zenhan
# export zenhan="C:\Users\nakam\Documents\nvim"
export zenhan="/mnt/c/Users/nakam/Documents/nvim/zenhan.exe"


# ---------- DENO ---------- #
export DENO_INSTALL="/Users/lukasgenshiro.nakamura/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# trash-cli initialization
if type trash-put &> /dev/null
then
    alias rm=trash-put
fi

# fuzzyfinder initializtion 
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh # windows
source <(fzf --zsh) # mac

# EOF (ctrl-d) does not exit the zsh
set -o ignoreeof

# Put symbolic links here
PATH=$PATH:$HOME/.local/bin

# -------------------- aliases -------------------- #

########## Quick access aliases
# Alias to easily edit and source this file
alias vi-rc="vi ~/.zshrc"
alias src-rc="source ~/.zshrc"

# Tidbits file
alias cd-tid="cd ~/tidbits/"
alias vi-tid="vi --cmd 'cd ~/dotfiles/' ~/dotfiles/tidbits/tidbits/tidbits.md"
alias tid="vi --cmd 'cd ~/dotfiles/' ~/dotfiles/tidbits/tidbits/tidbits.md"

# dotfiles
alias cd-dot="cd ~/dotfiles/"
alias vi-dot="vi --cmd 'cd ~/dotfiles/' ."

# Keymap for editing neovim configurations
# alias cd-nvim="cd ~/dotfiles/neovim/.config/nvim/"
# alias vi-nvim="vi --cmd 'cd ~/dotfiles/neovim/.config/nvim/' ."
# alias nv="cd ~/dotfiles/neovim/.config/nvim/ && vi lua/plugins/init.lua"
alias nv="cd ~/.dotfiles/nvim/ && vi lua/plugins/init.lua"

# Open windows file explorer
alias open="explorer.exe ."

# Start browser sync in current directory and watch for changes in all files
alias bs="browser-sync start --server --files * --no-notify"

# ls alias
alias l="ls -l"
alias la="ls -la"

# tree without .gitignore files
alias treeignore="rg --files | tree --fromfile"

# vi
# open file if specified, else open current directory in netrw
# alias nvim="/Users/lukasgenshiro.nakamura/.local/share/nvim/nvim-macos-arm64/bin/nvim"
# vi () {
#     # -z is true if the string is null
#     if [[ -z $1 ]]; then
#         nvim
#     else
#         nvim "$@"
#     fi
# }


# Fast maneuvering
alias ..='cd ..'
alias ...='cd ../..'


# -------------------- WSL -------------------- #
# export PATH=$PATH:/mnt/c/Windows/System32

# Add VSCODE to path so you can use it with "code <directory / file>"
# export PATH=$PATH:"/mnt/c/Users/nakam/AppData/Local/Programs/Microsoft VS Code/bin/"

# Add explorer.exe to PATH so we can use the "open" command
# export PATH=$PATH:"/mnt/c/Windows/"
# # Since the "open" command didn't work for me, specify the location of the explorer application directly
# function explorer () {
#     if [[ $# -eq 0 ]]; then
#         /mnt/c/Windows/explorer.exe .
#     elif [[ $# -eq 1 ]]; then
#         /mnt/c/Windows/explorer.exe $1
#     else
#         echo "Only 0 or 1 argument is supported."
#     fi
# }

# nvm - node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Add golang to path
# export PATH=$PATH:/usr/local/go/bin

# golang for mac
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"


# drop linux cache command
# sudo sh -c "echo 3 >'/proc/sys/vm/drop_caches' && swapoff -a && swapon -a"

## custom by for 
alias vi /Users/lukasgenshiro.nakamura/.local/bin/nvim-macos-arm64/bin/nvim
export PATH=$HOME/.nodebrew/current/bin:$PATH


# pyenv stuff
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
# eval "$(pyenv virtualenv-init -)"

# set editor for github cli tool gh
export EDITOR="nvim"

# Aliases for work
alias front="cd ~/code/devenv-maker/onecareer2nd/frontend/"
alias back="cd ~/code/devenv-maker/onecareer2nd/backend/"
alias tmp="cd ~/code/oc2-tmp/onecareer2nd/frontend/"


# --------------------
# Neovim
# --------------------
alias vi="nvim"


# Add home brew to path on Linux (for mac is available by default)
# on Mac uname would return "Darwin"
if [[ "$(uname)" == "Linux" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
