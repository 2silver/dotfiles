# only for zsh-performance-test
# call with zprof
# zmodload zsh/zprof

# slow - use agnoster theme again
# source "$(brew --prefix)/opt/spaceship/spaceship.zsh"

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"
# important empty for spaceship
# ZSH_THEME="robbyrussell"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode disabled  # disable automatic updates

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 31

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
# we have had installed them via brew, no need to include hiere
#    zsh-autosuggestions
#    zsh-completions
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='code'
fi

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
source ~/.aliases
source ~/.functions


# bitwarden as SSH Agent
export SSH_AUTH_SOCK=/Users/nscgraf/.bitwarden-ssh-agent.sock


source $HOME/.local/bin/env

# must be on end
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  autoload -Uz compinit

  # only update completion cache once a day
  if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
      compinit
  else
      compinit -C
  fi
fi

. "$HOME/.local/bin/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="/Users/nscgraf/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# --- Workflow Aliases ---

# # 1. Schnell-Verbindung zur VM von deinem Mac aus
# if [ "$IS_ORBSTACK" = "false" ]; then
#     alias vm-connect='ssh dein-benutzername@dein-vhost.orb.local'
# fi

# # 2. Synchronisation von Konfigurationsdateien (z.B. .zshrc oder .gitconfig)
# # Tippe 'sync-config' auf dem Mac, um deine Config in die VM zu schieben
# if [ "$IS_ORBSTACK" = "false" ]; then
#     alias sync-config='scp ~/.zshrc dein-benutzername@dein-vhost.orb.local:~/.zshrc && echo "Config synchronisiert!"'
# fi

# # 3. Gemeinsames Verzeichnis öffnen
# # 'open-here' öffnet den aktuellen Ordner im Mac-Finder (wenn du in der VM bist, nutzt es OrbStack-Features)
# if [ "$IS_ORBSTACK" = "true" ]; then
#     alias open-here='explorer.exe .' # Unter Windows, für Mac-OrbStack meist über xdg-open oder orb-spezifische Tools
#     alias pbcopy='nc.traditional localhost 2224' # Falls du Zugriff auf das Clipboard des Hosts brauchst
# else
#     alias open-here='open .'
# fi

# # 4. Ressourcen-Monitor
# alias vm-stats='orb stats' # Falls die OrbStack CLI installiert ist



##################################
#
# --- Spaceship OrbStack Modul ---
if [[ "$(uname -r)" == *orbstack* ]]; then
    SPACESHIP_HOST_SHOW=true
    SPACESHIP_HOST_COLOR="red"
    # acivate our custom module in the prompt
    SPACESHIP_PROMPT_ORDER=(orbstack $SPACESHIP_PROMPT_ORDER)
fi

spaceship_orbstack() {
  if [[ "$(uname -r)" == *orbstack* ]]; then
    # Icon + Text if we are in OrbStack VM
    spaceship::section \
      --color "red" \
      --prefix "" \
      --suffix " " \
      "⌂ vm"
  else
    # Lokaler Modus: Hostname anzeigen
    spaceship::section \
      --color "blue" \
      --prefix "" \
      --suffix " " \
      "⌂ $(hostname -s)"
  fi
}

# Spaceship Prompt Konfiguration
SPACESHIP_PROMPT_ORDER=(
  orbstack      # our module for OrbStack VM detection
  time          # time in 24h format
  user          # username
  dir           # directory
  host          # hostname
  git           # git status
  line_sep      # line separator
  char          # prompt symbol
)
