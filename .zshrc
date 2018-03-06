# Path to your oh-my-zsh installation.
export ZSH=/Users/nscgraf/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
ZSH_THEME="cobalt2"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH="/usr/local/bin:/usr/local/opt:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:$PATH"
export EDITOR='subl -w'
# export MANPATH="/usr/local/man:$MANPATH"

# deactivate share_history
unsetopt share_history

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
source /usr/local/opt/nvm/nvm.sh
source ~/.aliases
source ~/.functions

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

# nvm
export PATH="$PATH:$HOME/.nvm" #
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

# autoload .nvmrc if availiable in current folder
# nvm -> nodejs version manager
autoload -U add-zsh-hook
load-nvmrc() {
  if [[ -f .nvmrc && -r .nvmrc ]]; then
    nvm use
  fi
}
add-zsh-hook chpwd load-nvmrc

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH="/usr/local/opt/openssl/bin:$PATH"
