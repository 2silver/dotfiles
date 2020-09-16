#!/usr/bin/env bash

# Only enable exit-on-error after the non-critical colorization stuff,
# which may fail on systems lacking tput or terminfo
set -e

# setup Variables
VSCODE_USERPATH="$HOME/Library/Application\ Support/Code/User";
VSCODE_DOTFILEPATH="$HOME/.dotfiles/init/vscode/"

# Use colors, but only if connected to a terminal, and that terminal supports them.
if which tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
  RED="$(tput setaf 1)"
  GREEN="$(tput setaf 2)"
  YELLOW="$(tput setaf 3)"
  BLUE="$(tput setaf 4)"
  BOLD="$(tput bold)"
  NORMAL="$(tput sgr0)"
else
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  BOLD=""
  NORMAL=""
fi

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

append_to_zshrc() {
  local text="$1" zshrc
  local skip_new_line="${2:-0}"

  if [ -w "$HOME/.zshrc.local" ]; then
    zshrc="$HOME/.zshrc.local"
  else
    zshrc="$HOME/.zshrc"
  fi

  if ! grep -Fqs "$text" "$zshrc"; then
    if [ "$skip_new_line" -eq 1 ]; then
      printf "%s\n" "$text" >> "$zshrc"
    else
      printf "\n%s\n" "$text" >> "$zshrc"
    fi
  fi
}

main(){

  if [ ! -n "$DIR" ]; then
    DIR=~/.dotfiles
  fi

  # Install HomeBrew
  if ! command -v brew >/dev/null; then
    fancy_echo "Installing Homebrew ..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

    append_to_zshrc

    # shellcheck disable=SC2016
    append_to_zshrc 'export PATH="/usr/local/bin:$PATH"' 1

    export PATH="/usr/local/bin:$PATH"
  fi

  # Prevent the cloned repository from having insecure permissions. Failing to do
  # so causes compinit() calls to fail with "command not found: compdef" errors
  # for users with insecure umasks (e.g., "002", allowing group writability). Note
  # that this will be ignored under Cygwin by default, as Windows ACLs take
  # precedence over umasks except for filesystems mounted with option "noacl".
  umask g-w,o-w

  # make an symbolic link for all . in folder .dotfiles
  ln -sf ~/.dotfiles/.* ~/

  # setup all configs ...
  # Load bash profile
  source ~/.bash_profile;

  # install brew + cask packages
  brew install git

  # install oh-my-zsh
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  cp "$HOME/.dotfiles/init/iterm/cobalt2.zsh-theme" "$ZSH/themes/"
  cp ./.zshrc ~/.zshrc

  # install brew + cask
  # source .brew
  # source .cask

  # install nvm -> does not work with brew
  curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

  ## rvm
  curl -sSL https://get.rvm.io | bash -s stable

  # Microsoft Visual Code
  # Make settings folder if it doesn't exist
  if [[ ! -d "$VSCODE_USERPATH" ]]; then
    fancy_echo "[vscode settings] Making settings folder.. ($ST_USERPATH)"
    ln -sfn "$VSCODE_DOTFILEPATH"/* "$VSCODE_USERPATH"
  fi
  # If file exists already, move into dotfiles (git will track differences)
  if [[ -f "$VSCODE_USERPATH" ]] && [[ ! -h "$VSCODE_USERPATH" ]]; then
    fancy_echo "[vscode settings] User settings found, moving into dotfiles.. ($VSCODE_DOTFILEPATH)"
    rm -rf "$VSCODE_USERPATH"
    ln -sfn "$VSCODE_DOTFILEPATH"/* "$VSCODE_USERPATH"
  fi

  # if automatic is not working use this
  # ln -s /Users/nscgraf/.dotfiles/init/vscode/settings.json /Users/nscgraf/Library/Application\ Support/Code/User/settings.json
  # ln -s /Users/nscgraf/.dotfiles/init/vscode/keybindings.json /Users/nscgraf/Library/Application\ Support/Code/User/keybindings.json
  # ln -s /Users/nscgraf/.dotfiles/init/vscode/snippets/ /Users/nscgraf/Library/Application\ Support/Code/User
  # END

  fancy_echo "${GREEN}"
  echo ''
  echo '     _       _    __ _ _           '
  echo '    | |     | |  / _(_) |          '
  echo '  __| | ___ | |_| |_ _| | ___  ___ '
  echo ' / _` |/ _ \| __|  _| | |/ _ \/ __|'
  echo '| (_| | (_) | |_| | | | |  __/\__ \'
  echo ' \__,_|\___/ \__|_| |_|_|\___||___/    .... are now installed'
  echo ''
  echo ''
  echo 'Setup complete, thank you'
  echo ''
  echo ''
  fancy_echo "${NORMAL}"
}

read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
  main;
  say Installation finished;
fi;
unset main;
