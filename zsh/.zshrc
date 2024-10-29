# --------------------
# Powerlevel10k (Promptline)
# --------------------

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# --------------------
# Oh-my-zsh
# --------------------
# TODO: zsh-autocomplete is nice for completing commands but too much clutter. Find a way that is not this intrusive
# plugins=(git nvm zsh-autosuggestions zsh-syntax-highlighting zsh-autocomplete)

# colorscheme for zsh syntax highlighting (source before loadig the zsh-syntax-highlighting plugin)
source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
zstyle ':omz:plugins:nvm' lazy yes

# Plugins
plugins=(git nvm zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh


# --------------------
# Utility aliases
# --------------------

alias rc="vi ~/.zshrc"
alias src="source ~/.zshrc"

# Tidbits file
alias tid="vi --cmd 'cd ~/tidbits/' git.md"

# dotfiles
alias dotfiles="cd ~/.dotfiles"

# Keymap for editing neovim configurations
alias nv="cd ~/.dotfiles/nvim/ && vi lua/plugin.lua"

# Open windows file explorer
alias open="explorer.exe ."

# ls alias
alias l="ls -l"
alias la="ls -la"

# Fast maneuvering
alias ..='cd ..'
alias ...='cd ../..'

# 'tree' command that excludes files in .gitignore
alias treeignore="rg --files | tree --fromfile"


# --------------------
# Brew
# --------------------
# Add home brew to path on Linux (for mac is available by default)
# on Mac uname would return "Darwin"
if [[ "$(uname)" == "Linux" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi


# --------------------
# Deno
# --------------------
export DENO_INSTALL="/Users/lukasgenshiro.nakamura/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"



# --------------------
# Trash CLI
# --------------------
# trash-cli initialization
if type trash-put &> /dev/null
then
    alias rm=trash-put
fi


# --------------------
# Golang
# --------------------
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
# eval "$(goenv init -)"
eval "$(goenv init -)"


# --------------------
# Node
# --------------------
# nvm - node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH=$HOME/.nodebrew/current/bin:$PATH


# --------------------
# Python
# --------------------
# pyenv stuff
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


# --------------------
# Git
# --------------------
export EDITOR="nvim" # set editor for github cli tool gh
alias ghpr="gh pr create -a @me"
alias ghv="gh pr view --web"
alias gs="git stash"


# --------------------
# Neovim
# --------------------
alias vi="nvim"


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
export FZF_DEFAULT_COMMAND="fd . $HOME"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# TODO: Make it so ~ part is replaced by ~ not this long unnecessary prepend
# Ignore Library directory for mac & search under HOME & devenv-maker which is ignored under HOME because of .gitignore
# export FZF_ALT_C_COMMAND="fd --base-directory ~  -E Library -t d . code/devenv-maker/*" 

# export FZF_ALT_C_COMMAND="fd -E Library -t d . ~ ~/code/devenv-maker/*" 
# export FZF_ALT_C_COMMAND="fd -E Library -t d . ~/code/devenv-maker/*" 
export FZF_ALT_C_COMMAND="fd -E Library -t d" 
set -o ignoreeof # accidental close prevention - EOF (ctrl-d) does not exit the zsh

alias gbs="git branch | fzf | cut -c 3- | xargs git switch"

source ~/fzf-git.sh



# --------------------
# Ruby
# --------------------
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"


# --------------------
# Mise
# --------------------
# eval "$(/Users/lukasgenshiro.nakamura/.local/bin/mise activate zsh)"


# --------------------
# Other
# --------------------
# For neovim, setting IME with zenhan
# export zenhan="C:\Users\nakam\Documents\nvim"
export zenhan="/mnt/c/Users/nakam/Documents/nvim/zenhan.exe"

# Put symbolic links here
PATH=$PATH:$HOME/.local/bin


# --------------------
# Load local settings (Should come last)
# --------------------
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

. "$HOME/.cargo/env"
