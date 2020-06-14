#!/usr/bin/env bash

# thanks to brew for sh code parts !!

main(){
  # Use colors, but only if connected to a terminal, and that terminal
  # supports them.
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

  # Only enable exit-on-error after the non-critical colorization stuff,
  # which may fail on systems lacking tput or terminfo
  set -e

  # setup Variables
  VSCODE_USERPATH="$HOME/Library/Application\ Support/Code/User";
  VSCODE_DOTFILEPATH="$HOME/.dotfiles/init/vscode/"

  if [ ! -n "$DIR" ]; then
    DIR=~/.dotfiles
  fi

  # Install HomeBrew
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  # install brew + cask packages
  brew install git
  # we can now fetch out .dotfiles from repository

  # Prevent the cloned repository from having insecure permissions. Failing to do
  # so causes compinit() calls to fail with "command not found: compdef" errors
  # for users with insecure umasks (e.g., "002", allowing group writability). Note
  # that this will be ignored under Cygwin by default, as Windows ACLs take
  # precedence over umasks except for filesystems mounted with option "noacl".
  umask g-w,o-w

  printf "${BLUE}Cloning Dotfiles...${NORMAL}\n"
  hash git >/dev/null 2>&1 || {
    echo "Error: git is not installed"
    exit 1
  }
  # The Windows (MSYS) Git is not compatible with normal use on cygwin
  if [ "$OSTYPE" = cygwin ]; then
    if git --version | grep msysgit > /dev/null; then
      echo "Error: Windows/MSYS Git is not supported on Cygwin"
      echo "Error: Make sure the Cygwin git package is installed and is first on the path"
      exit 1
    fi
  fi
  env git clone https://github.com/2silver/dotfiles $DIR || {
    printf "Error: git clone of .dotfiles repo failed\n"
    exit 1
  }

  # make an symbolic link for all . in folder .dotfiles
  ln -sf ~/.dotfiles/.* ~/

  # setup all configs ...
  # Load bash profile
  source ~/.bash_profile;
  ## nodejs / nvm
  # install nvm -> does not work with brew
  curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh |  bash
  ## rvm
  curl -sSL https://get.rvm.io | bash -s stable

  # install brew + cask
  source .brew
  source .cask

  # install oh-my-zsh
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  cp "$HOME/.dotfiles/init/iterm/cobalt2.zsh-theme" "$ZSH/themes/"
  cp ./.zshrc ~/.zshrc

  # Microsoft Visual Code
  # Make settings folder if it doesn't exist
  if [[ ! -d "$VSCODE_USERPATH" ]]; then
    echo "[vscode settings] Making settings folder.. ($ST_USERPATH)"
    ln -sfn "$VSCODE_DOTFILEPATH"/* "$VSCODE_USERPATH"
  fi
  # If file exists already, move into dotfiles (git will track differences)
  if [[ -f "$VSCODE_USERPATH" ]] && [[ ! -h "$VSCODE_USERPATH" ]]; then
    echo "[vscode settings] User settings found, moving into dotfiles.. ($VSCODE_DOTFILEPATH)"
    rm -rf "$VSCODE_USERPATH"
    ln -sfn "$VSCODE_DOTFILEPATH"/* "$VSCODE_USERPATH"
  fi

  printf "${GREEN}"
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
  printf "${NORMAL}"
}

read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
  main;
  say Automatische Installation abgeschlossen!;
  say Nicht vergessen, Pakete installieren;
fi;
unset main;
