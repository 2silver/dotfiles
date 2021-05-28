# Path to your oh-my-zsh installation.
export ZSH=/Users/nscgraf/.oh-my-zsh

ZSH_THEME="agnoster"

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# install zsh-completions, zsh-autosuggestions via breww
# if type brew &>/dev/null; then
#   FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

#   autoload -Uz compinit
#   compinit
# fi
# 
# source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# END

plugins=(
  zsh-completions
  zsh-autosuggestions
  git
  git-prompt
  history
  pyenv
  python
)
autoload -U compinit && compinit

source $ZSH/oh-my-zsh.sh

# User configuration
export PATH="/usr/local/bin:/usr/local/opt:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:$PATH"
export EDITOR='code'
export MANPATH="/usr/local/man:$MANPATH"

# Update homebrew once a week
export HOMEBREW_AUTO_UPDATE_SECS=86400

# deactivate share_history
# unsetopt share_history

source ~/.aliases
source ~/.functions

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
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
