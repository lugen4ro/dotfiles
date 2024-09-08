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
plugins=(git nvm zsh-autosuggestions zsh-syntax-highlighting)
# TODO: zsh-autocomplete is nice for completing commands but too much clutter. Find a way that is not this intrusive
# plugins=(git nvm zsh-autosuggestions zsh-syntax-highlighting zsh-autocomplete)

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



# Put symbolic links here
PATH=$PATH:$HOME/.local/bin

# -------------------- aliases -------------------- #

########## Quick access aliases
alias rc="vi ~/.zshrc"
alias src="source ~/.zshrc"

# Tidbits file
alias cd-tid="cd ~/tidbits/"
alias vi-tid="vi --cmd 'cd ~/.dotfiles/' ~/.dotfiles/tidbits/tidbits/tidbits.md"
alias tid="vi --cmd 'cd ~/.dotfiles/' ~/.dotfiles/tidbits/tidbits/tidbits.md"

# dotfiles
alias dot="cd ~/.dotfiles && vi Taskfile.yaml"

# Keymap for editing neovim configurations
# alias vi-nvim="vi --cmd 'cd ~/dotfiles/neovim/.config/nvim/' ."
alias nv="cd ~/.dotfiles/nvim/ && vi lua/plugins/init.lua"

# Open windows file explorer
alias open="explorer.exe ."

# ls alias
alias l="ls -l"
alias la="ls -la"

# tree without .gitignore files
alias treeignore="rg --files | tree --fromfile"


# Fast maneuvering
alias ..='cd ..'
alias ...='cd ../..'

# nvm - node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# golang for mac
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"

# drop linux cache command
# sudo sh -c "echo 3 >'/proc/sys/vm/drop_caches' && swapoff -a && swapon -a"

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


# --------------------
# bat
# --------------------
export BAT_THEME="Catppuccin Mocha"


# --------------------
# Delta 
# --------------------
export DELTA_FEATURES=+side-by-side # activate by default
alias dt='delta-toggle'
function delta-toggle () {
    if [[ "$DELTA_FEATURES" == *"+side-by-side"* ]]; then
        # If "side-by-side" is already enabled, turn it off
        export DELTA_FEATURES=$(echo "$DELTA_FEATURES" | sed 's/+side-by-side//')
    else
        # If "side-by-side" is not enabled, turn it on
        if [[ -z "$DELTA_FEATURES" ]]; then
            export DELTA_FEATURES="+side-by-side"
        else
            export DELTA_FEATURES="$DELTA_FEATURES +side-by-side"
        fi
    fi
}


# --------------------
# fzf
# --------------------
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
alias gb="git branch | fzf | cut -c 3- | xargs git switch"
export FZF_DEFAULT_COMMAND="fd . $HOME"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -t d . $HOME"
set -o ignoreeof # accidental close prevention - EOF (ctrl-d) does not exit the zsh
