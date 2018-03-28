# Path to your oh-my-zsh installation.
export ZSH=/Users/nscgraf/.oh-my-zsh

ZSH_THEME="agnoster"

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

plugins=(zsh-completions zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration
export PATH="/usr/local/bin:/usr/local/opt:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:$PATH"
export EDITOR='subl -w'
export MANPATH="/usr/local/man:$MANPATH"

# deactivate share_history
unsetopt share_history

source ~/.aliases
source ~/.functions
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# rvm
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" 

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# autoload .nvmrc if availiable in current folder
autoload -U add-zsh-hook
load-nvmrc() {
  if [[ -f .nvmrc && -r .nvmrc ]]; then
    nvm use
  fi
}
add-zsh-hook chpwd load-nvmrc

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
export PATH="/usr/local/opt/openssl/bin:$PATH"

# python2 (brew)
export PATH="/usr/local/opt/python@2/libexec/bin:$PATH"