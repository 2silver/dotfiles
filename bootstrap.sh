#!/usr/bin/env bash

ST_USERPATH="$HOME/Library/Application Support/Sublime Text 3/Packages/User";
ST_SETTINGSPATH="$ST_USERPATH/Preferences.sublime-settings"
ST_PACKAGESPATH="$ST_USERPATH/Package Control.sublime-settings"
ST_SETTINGSDOTFILEPATH="$HOME/.dotfiles/init/sublimetext/Preferences.sublime-settings"
ST_PACKAGESDOTFILEPATH="$HOME/.dotfiles/init/sublimetext/Package Control.sublime-settings"

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
  cp ./.zshrc ~/.zshrc

  # Sublime Text
  # Make settings folder if it doesn't exist
  if [[ ! -d "$ST_USERPATH" ]]; then
    echo "[sublimetext settings] Making settings folder.. ($ST_USERPATH)"
    mkdir -p "$ST_USERPATH"
  fi
  # If file exists already, move into dotfiles (git will track differences)
  if [[ -f "$ST_SETTINGSPATH" ]] && [[ ! -h "$ST_SETTINGSPATH" ]]; then
    echo "[sublimetext settings] User settings found, moving into dotfiles.. ($ST_SETTINGSDOTFILEPATH)"
    mv "$ST_SETTINGSPATH" "$ST_SETTINGSDOTFILEPATH"
  fi
  
  if [[ ! -L "$ST_SETTINGSPATH" ]]; then
    echo "[sublimetext settings] Symlinking settings path to dotfiles.. ($ST_SETTINGSPATH)"
    ln -s "$ST_SETTINGSDOTFILEPATH" "$ST_SETTINGSPATH"
  else
    echo "[sublimetext settings] Everything looks good here. Nothing to setup."
  fi

  # If file exists already, move into dotfiles (git will track differences)
  if [[ -f "$ST_PACKAGESPATH" ]] && [[ ! -h "$ST_PACKAGESPATH" ]]; then
    echo "[sublimetext packages] User packages found, moving into dotfiles.. ($ST_PACKAGESPATH)"
    mv "$ST_PACKAGESPATH" "$ST_PACKAGESDOTFILEPATH"
  fi
  
  if [[ ! -L "$ST_PACKAGESPATH" ]]; then
    echo "[sublimetext packages] Symlinking packages path to dotfiles.. ($ST_PACKAGESPATH)"
    ln -s "$ST_PACKAGESDOTFILEPATH" "$ST_PACKAGESPATH"
  else
    echo "[sublimetext packages] Everything looks good here. Nothing to setup."
  fi

  ln -sf "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" ~/bin/subl

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