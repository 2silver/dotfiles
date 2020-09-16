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

main(){
  INSTALLED=()

  fancy_echo "Install .ssh Folder and set permission"
  mkdir ~/.ssh \
  && chmod 700 ~/.ssh \
  && touch ~/.ssh/authorized_keys \
  && chmod 644 ~/.ssh/authorized_keys \
  && touch ~/.ssh/known_hosts \
  && chmod 644 ~/.ssh/known_hosts
  fancy_echo "===> SSH Setup -> ${GREEN}done${NORMAL}"

  fancy_echo "Please copy your SSH-Key's"
  read -n 1 -s -r -p "Press any key to continue"
  echo
  echo
  open ~/.ssh
  read -n 1 -s -r -p "Files copied ? Press any key to continue"
  echo
  echo
  if [ -n "~/.ssh/id_rsa" ]; then
    chmod 644 ~/.ssh/*.pub && chmod 600 ~/.ssh/id_rsa
    fancy_echo "===> SSH Permissions ${GREEN}done${NORMAL}"
  else
    fancy_echo "${GREEN}OK${NORMAL}, no SSH-Keys are installed...."
  fi

  fancy_echo "- Installing Apple Developer Tools"
  xcode-select --install
  fancy_echo "===> Apple Developer Tools ${GREEN}done${NORMAL}"
  INSTALLED+=('apple-developer-tools')

  # Install HomeBrew
  if ! command -v brew >/dev/null; then
    fancy_echo "- Installing Homebrew ..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    brew doctor
    brew update

    # So we use all of the packages we are about to install
    echo "export PATH='/usr/local/bin:$PATH'\n" >> ~/.bashrc
    source ~/.bashrc

    export PATH="/usr/local/bin:$PATH"
    fancy_echo "===> Homebrew ${GREEN}done${NORMAL}"
    INSTALLED+=('homebrew')
  fi

  # install brew + cask packages
  fancy_echo "- Homebrew git ..."
  brew install git
  fancy_echo "===> Homebrew Git ${GREEN}done${NORMAL}"
  INSTALLED+=('homebrew - git')

  # git clone dotfiles repo
  cd ~ && git clone git@github.com:2silver/dotfiles.git ./.dotfiles

  # make an symbolic link for all . in folder .dotfiles
  fancy_echo "- Symbolic Link for dotfiles ..."
  ln -sf ~/.dotfiles/.aliases ~/.aliases &&\
  ln -sf ~/.dotfiles/.bash_profile ~/.bash_profile &&\
  ln -sf ~/.dotfiles/.buildout ~/.buildout &&\
  ln -sf ~/.dotfiles/.editorconfig ~/.editorconfig &&\
  ln -sf ~/.dotfiles/.eslintrc ~/.eslintrc &&\
  ln -sf ~/.dotfiles/.exports ~/.exports &&\
  ln -sf ~/.dotfiles/.functions ~/.functions &&\
  ln -sf ~/.dotfiles/.gitattributes ~/.gitattributes &&\
  ln -sf ~/.dotfiles/.gitconfig ~/.gitconfig &&\
  ln -sf ~/.dotfiles/.gitignore ~/.gitignore &&\
  ln -sf ~/.dotfiles/.htmlhintrc ~/.htmlhintrc &&\
  ln -sf ~/.dotfiles/.inputrc ~/.inputrc &&\
  ln -sf ~/.dotfiles/.isort.cfg ~/.isort.cfg &&\
  ln -sf ~/.dotfiles/.screenrc ~/.screenrc &&\
  ln -sf ~/.dotfiles/.stylelintrc ~/.stylelintrc &&\
  ln -sf ~/.dotfiles/.vim ~/.vim &&\
  ln -sf ~/.dotfiles/.vimrc ~/.vimrc &&\
  ln -sf ~/.dotfiles/.wgetrc ~/.wgetrc &&\
  ln -sf ~/.dotfiles/.zshrc ~/.zshrc
  fancy_echo "===> Symbolic Links ${GREEN}done${NORMAL}"
  INSTALLED+=('symbolic links')

  # install oh-my-zsh
  if [ ! -n "~/.zshrc" ]; then
      echo "$FILE exists."
      fancy_echo "- Zsh ..."
      sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
      cp "$HOME/.dotfiles/init/iterm/cobalt2.zsh-theme" "$ZSH/themes/"
      cp ./.zshrc ~/.zshrc
      fancy_echo "===> ZSH ${GREEN}done${NORMAL}"
      INSTALLED+=('zsh')
  fi

  # # install brew + cask
  fancy_echo "- brew / cask ..."
  source ~/.dotfiles/.brew
  fancy_echo "===> Brew ${GREEN}done${NORMAL}"
  INSTALLED+=('brew')
  source ~/.dotfiles/.cask
  fancy_echo "===> Casks ${GREEN}done${NORMAL}"
  INSTALLED+=('casks')

  # install nvm -> does not work with brew
  if ! command -v nvm >/dev/null; then
    fancy_echo "- Node Version Manager ..."
    curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
    fancy_echo "===> NVM ${GREEN}done${NORMAL}"
    INSTALLED+=('nvm')
  fi

  ## rvm
  if ! command -v rvm >/dev/null; then
    fancy_echo "- Ruby Version Manager ..."
    curl -sSL https://get.rvm.io | bash -s stable
    fancy_echo "===> RVM ${GREEN}done${NORMAL}"
    INSTALLED+=('rvm')
  fi

  # Microsoft Visual Code
  if ! command -v code >/dev/null; then
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
    fancy_echo "===> VS Code Settings ${GREEN}done${NORMAL}"
    INSTALLED+=('vscode-settings')
  fi

  # if automatic is not working use this
  # ln -s /Users/nscgraf/.dotfiles/init/vscode/settings.json /Users/nscgraf/Library/Application\ Support/Code/User/settings.json
  # ln -s /Users/nscgraf/.dotfiles/init/vscode/keybindings.json /Users/nscgraf/Library/Application\ Support/Code/User/keybindings.json
  # ln -s /Users/nscgraf/.dotfiles/init/vscode/snippets/ /Users/nscgraf/Library/Application\ Support/Code/User
  # END

  # # setup all configs ...
  # fancy_echo "- Bash Profile ..."
  # # Load bash profile
  # source ~/.bash_profile
  # fancy_echo "===> Bash Profile ${GREEN}done${NORMAL}"
  # INSTALLED+=('bash_profile')

  fancy_echo "${GREEN}"
  fancy_echo ''
  fancy_echo '     _       _    __ _ _           '
  fancy_echo '    | |     | |  / _(_) |          '
  fancy_echo '  __| | ___ | |_| |_ _| | ___  ___ '
  fancy_echo ' / _` |/ _ \| __|  _| | |/ _ \/ __|'
  fancy_echo '| (_| | (_) | |_| | | | |  __/\__ \'
  fancy_echo ' \__,_|\___/ \__|_| |_|_|\___||___/    .... are now installed'
  fancy_echo ''
  fancy_echo ''
  echo ${SYMLINKS[@]}
  echo -e "\n====== All Done!! ======\n"
  echo
  fancy_echo 'Setup complete, thank you'
  fancy_echo ''
  fancy_echo ''
  fancy_echo "${NORMAL}"
}

read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
echo "";
if [[ $REPLY =~ ^[Yy]$ ]]; then
  main;
  say Installation finished;
fi;
unset main;
