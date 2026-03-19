#performance: Profiling
# zmodload zsh/zprof

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"

zstyle ':omz:update' mode disabled
zstyle ':omz:update' frequency 31

plugins=(git)

source $ZSH/oh-my-zsh.sh

# --- agnoster + orbstack ---
# show supported colors
# for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#5}:+$'\n'}; done
prompt_whichhost() {
  # not working wihtout install our dotfiles on remote - we do not want to do that
  # we only test local vm's (orbstack)
  # if [[ -n "$SSH_CONNECTION" || -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
  #   local remote_host="${HOST:-$(hostname -s 2>/dev/null)}"
  #   remote_host="${remote_host%%.*}"
  #   prompt_segment 161 white "🌐 ${USER}@${remote_host}"
  # elif [[ "$(uname -r)" == *orbstack* ]]; then
  #   prompt_segment 124 white "🏘️ vm"
  if [[ "$(uname -r)" == *orbstack* ]]; then
    prompt_segment 124 white "🏘️ vm"
  else
    prompt_segment 242 white "🏠 local"
  fi
}

# new prompt function to include orbstack segment
build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_whichhost
  prompt_virtualenv
  prompt_terraform
  prompt_context
  prompt_dir
  prompt_git
  prompt_end #  important to reset colors
  # original segments (commented out for now)
  # prompt_status
  # prompt_virtualenv
  # prompt_aws
  # prompt_terraform
  # prompt_context
  # prompt_dir
  # prompt_git
  # prompt_bzr
  # prompt_hg
  # prompt_end
}

# --- User Configuration ---
export EDITOR='code'
[[ -n $SSH_CONNECTION ]] && export EDITOR='vim'

[[ -f ~/.aliases ]] && source ~/.aliases
[[ -f ~/.functions ]] && source ~/.functions

# Bitwarden SSH
export SSH_AUTH_SOCK="/Users/nscgraf/.bitwarden-ssh-agent.sock"

# --- Tooling & PATH ---
# pnpm
export PNPM_HOME="/Users/nscgraf/Library/pnpm"
export PATH="$PNPM_HOME:$PATH:$HOME/.local/bin"

# NVM (lazy loading with aliases to ensure nvm is loaded when using node/npm)
if [ -s "$HOME/.nvm/nvm.sh" ]; then
  alias nvm='unalias nvm node npm; [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"; nvm'
  alias node='unalias nvm node npm; [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"; node'
  alias npm='unalias nvm node npm; [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"; npm'
fi

# --- Brew Plugins & Completions ---
if type brew &>/dev/null; then
  BREW_PREFIX=$(brew --prefix)

  # Autosuggestions
  source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

  # Completions (optimized compinit)
  FPATH="$BREW_PREFIX/share/zsh-completions:$FPATH"
  autoload -Uz compinit
  if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
    compinit
  else
    compinit -C
  fi
fi

# --- OrbStack Workflow Aliases ---
if [[ "$(uname -r)" == *orbstack* ]]; then
    alias open-here='explorer.exe .'
    alias pbcopy='nc.traditional localhost 2224'
else
    alias vm-connect='ssh nscgraf@orbstack.local'
    alias vm-stats='orb stats'
    alias open-here='open .'
fi
