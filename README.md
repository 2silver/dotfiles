## Pre-Installation

- backup SSH Keys


## Installation

- Install SSH-Key
    ```bash
    mkdir ~/.ssh && chmod 700 ~/.ssh && touch ~/.ssh/authorized_keys && chmod 644 ~/.ssh/authorized_keys && touch ~/.ssh/known_hosts && chmod 644 ~/.ssh/known_hosts
    ```
    Copy/Move/Generate SSH-Keys
    ```bash
    chmod 644 ~/.ssh/*.pub && chmod 600 ~/.ssh/id_rsa
    ```
- Install Apple Developer Tools for Current OSX
    ```bash
    xcode-select --install
    ```
- Using Git and the bootstrap script
    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/2silver/dotfiles/c07319b6c2e025740712ad65ab19b32e78e55fec/bootstrap.sh)"
    ```

### Install fonts
```bash
open ~/.dotfiles/init/fonts
```

### Sensible OS X defaults
When setting up a new Mac, you may want to set some sensible OS X defaults:

```bash
source ./.dotfiles/.macosx
```

### Install packages

view packages.md