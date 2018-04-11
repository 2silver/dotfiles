#!/usr/bin/env bash
VSCODE_USERPATH="$HOME/Library/Application\ Support/Code/User";
VSCODE_DOTFILEPATH="$HOME/.dotfiles/init/vscode/"

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function doIt() {
  rsync --exclude ".git/" \
        --exclude ".DS_Store" \
        --exclude ".macosx" \
        --exclude "bootstrap.sh" \
        --exclude "README.md" \
        --exclude ".zshrc" \
        --exclude "init" \
        -avh --no-perms . ~;

  # Load bash profile
  source ~/.bash_profile;

  #
  ## nodejs / nvm
  # install nvm -> does not work view brew
  curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh |  bash

  #
  ## rvm
  curl -sSL https://get.rvm.io | bash -s stable

  source .brew
  source .cask

  # install oh-my-zsh
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  cp "$HOME/.dotfiles/init/iterm/cobalt2.zsh-theme" "$ZSH/themes/"
  cp ./.zshrc ~/.zshrc

  # Sublime Text
  # Make settings folder if it doesn't exist
  if [[ ! -d "$VSCODE_USERPATH" ]]; then
    echo "[vscode settings] Making settings folder.. ($ST_USERPATH)"
    ln -s "$VSCODE_DOTFILEPATH"/* "$VSCODE_USERPATH"
  fi
  # If file exists already, move into dotfiles (git will track differences)
  if [[ -f "$VSCODE_USERPATH" ]] && [[ ! -h "$VSCODE_USERPATH" ]]; then
    echo "[vscode settings] User settings found, moving into dotfiles.. ($VSCODE_DOTFILEPATH)"
    rm -rf "$VSCODE_USERPATH"
    ln -s "$VSCODE_DOTFILEPATH"/* "$VSCODE_USERPATH"
  fi

}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
  doIt;
else
  read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
  echo "";
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    doIt;
    say Automatische Installation abgeschlossen!;
    say Nicht vergessen, Pakete installieren;
  fi;
fi;

unset doIt;
