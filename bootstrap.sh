#!/usr/bin/env bash

ST_USERPATH="$HOME/Library/Application Support/Sublime Text 3/Packages/User";
ST_SETTINGSPATH="$ST_USERPATH/Preferences.sublime-settings"
ST_DOTFILEPATH="HOME/.dotfiles/init/sublimetext/Preferences.sublime-settings"

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
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)";
  cp ./.zshrc ~/.zshrc;

  # Sublime Text
  # Make settings folder if it doesn't exist
  if [[ ! -d "$ST_USERPATH" ]]; then
    echo "[sublimetext] Making settings folder.. ($ST_USERPATH)"
    mkdir -p "$ST_USERPATH"
  fi
  # If file exists already, move into dotfiles (git will track differences)
  if [[ -f "$ST_SETTINGSPATH" ]] && [[ ! -h "$ST_SETTINGSPATH" ]]; then
    echo "[sublimetext] User settings found, moving into dotfiles.. ($ST_DOTFILEPATH)"
    mv "$ST_SETTINGSPATH" "$ST_DOTFILEPATH"
  fi
  
  if [[ ! -L "$ST_SETTINGSPATH" ]]; then
    echo "[sublimetext] Symlinking settings path to dotfiles.. ($ST_SETTINGSPATH)"
    ln -s "$ST_DOTFILEPATH" "$ST_SETTINGSPATH"
  else
    echo "[sublimetext] Everything looks good here. Nothing to setup."
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
    open ./packages.md
  fi;
fi;

unset doIt;


# new from me

# create symlinks
# ---------------
# sublime text 3 user preferences
# ln -fs ~/.dotfiles/init/Sublime\ Text\ 3/User/* ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
