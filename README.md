## Pre-Installation

- backup SSH Keys


## Installation

### Using Git and the bootstrap script

### Install Homebrew
```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

### Copy SSH-Key

###Clone dotfile Repository and install

```bash
cd ~/ && git clone git@bitbucket.org:polygonstudio/dotfiles.git ./.dotfiles && cd ./.dotfiles && source bootstrap.sh
```

### Sensible OS X defaults
When setting up a new Mac, you may want to set some sensible OS X defaults:

```bash
source ./.dotfiles/.macosx
```


### Install packages

view packages.md