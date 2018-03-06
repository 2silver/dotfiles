#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function doIt() {
  rsync --exclude ".git/" \
        --exclude ".DS_Store" \
        --exclude ".macos" \
        --exclude "bootstrap.sh" \
        --exclude "README.md" \
        -avh --no-perms . ~;

  # Load bash profile
  source ~/.bash_profile;

  source .brew
  source .cask

  # Symlink subl command
  ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" ~/bin/subl

  # Switch shell to Bash 4
  BASHPATH=$(brew --prefix)/bin/bash;
  sudo echo $BASHPATH >> /etc/shells;
  chsh -s $BASHPATH;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
  doIt;
else
  read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
  echo "";
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    doIt;
  fi;
fi;
unset doIt;




# new from me

# create symlinks
# ---------------
# sublime text 3 user preferences
# ln -fs ~/.dotfiles/init/Sublime\ Text\ 3/User/* ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
