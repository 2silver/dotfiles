#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function doIt() {
  rsync --exclude ".git/" \
        --exclude ".DS_Store" \
        --exclude ".macosx" \
        --exclude "bootstrap.sh" \
        --exclude "README.md" \
        -avh --no-perms . ~;

  # NOT WORKING WITH source
  # ln -sf ./.aliases ~/.aliases;
  # ln -sf ./.bash_profile ~/.bash_profile;
  # ln -sf ./.buildout ~/.buildout;
  # ln -sf ./.editorconfig ~/.editorconfig;
  # ln -sf ./.exports ~/.exports;
  # ln -sf ./.functions ~/.functions;
  # ln -sf ./.gitattributes ~/.gitattributes;
  # ln -sf ./.gitconfig ~/.gitconfig;
  # ln -sf ./.gitignore ~/.gitignore;
  # ln -sf ./.inputrc ~/.inputrc;
  # ln -sf ./.screenrc ~/.screenrc;
  # ln -sf ./.vim ~/.vim;
  # ln -sf ./.vimrc ~/.vimrc;
  # ln -sf ./.wgetrc ~/.wgetrc;

  # Load bash profile
  source ~/.bash_profile;

  # Sublime Text
  ln -sf "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" ~/bin/subl
  ln -sf "/Users/nscgraf/.dotfiles/init/Sublime\ Text\ 3/User/Package\ Control.sublime-settings" "/Users/nscgraf/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/"

  # install oh-my-zsh
  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)";
  cp ./.zshrc ~/.zshrc;

  # 
  ## nodejs / nvm
  # install nvm -> does not work view brew
  # curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh |  bash

  #
  ## rvm
  curl -sSL https://get.rvm.io | bash -s stable

  source .brew
  source .cask

  source .macosx
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


# new from me

# create symlinks
# ---------------
# sublime text 3 user preferences
# ln -fs ~/.dotfiles/init/Sublime\ Text\ 3/User/* ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User

# after reopen iterm
# install latest lts version
# nvm install --lts
# 
# # npm packages
# npm install -g eslint # for sublimelint
# npm install -g htmlhint@latest # for sublimelint
# 
# 
# # See your latest local git branches, formatted real fancy
# npm install --g git-recent
# # Recall what you did on the last working day. Psst! or be nosy and find what someone else in your team did ;-)
# npm install -g git-standup
# 
# 