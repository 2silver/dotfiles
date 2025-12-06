#!/usr/bin/env bash
#
# https://robferguson.org/blog/2017/10/06/how-to-brew install-opencv-and-python-using-homebrew-on-macos-sierra/
# http://docs.python-guide.org/en/latest/starting/brew install/osx/
#
set -euo pipefail
IFS=$'\n\t'

log()  { printf '%s\n' "$*"; }
warn() { printf 'WARN: %s\n' "$*" >&2; }

has_cmd() { command -v "$1" >/dev/null 2>&1; }
brew_has_formula() { brew info --formula "$1" >/dev/null 2>&1; }
brew_is_installed() { brew list --formula "$1" >/dev/null 2>&1; }

brew_install_safe() {
  local f="$1"
  if ! brew_has_formula "$f"; then
    warn "Skipping '$f' (formula not found)."
    return 0
  fi
  if brew_is_installed "$f"; then
    log "Already installed: $f"
    return 0
  fi
  log "Installing: $f"
  brew install --formula "$f"
}
###############################################################################

if ! has_cmd brew; then
  warn "Homebrew not found. Install Homebrew first: https://brew.sh/"
  exit 1
fi

###############################################################################
# Update macOS (Apple) components                                             #
###############################################################################
if [[ "${RUN_APPLE_UPDATES:-0}" == "1" ]]; then
  log "Updating Apple software (softwareupdate)..."
  sudo -v
  # Install all available Apple updates (may include reboots depending on updates)
  sudo softwareupdate --install --all --agree-to-license || true
fi

###############################################################################

log "Updating Homebrew..."
brew update

log "Upgrading installed formulae..."
brew upgrade

###############################################################################


###############################################################################
# Minimal, useful CLI tools                                                   #
###############################################################################

FORMULAE_MINIMAL=(
  # coreutils # macOS ships coreutils or do we need GNU coreutils ?
  # findutils # macOS ships find, do we need GNU find ?
  # grep # macOS ships grep, do we need GNU grep ?
  highlight
  tree
  wget
  tig
)

###############################################################################
# Shell extras (keep lean)                                                    #
# Note: macOS already ships zsh; installing Homebrew zsh is optional.         #
###############################################################################

FORMULAE_SHELL=(
  zsh-autosuggestions
  zsh-completions
  spaceship
  # zsh
)

# Optional
FORMULAE_OPTIONAL_SHELL=(
  # rename # --> part of perl on macO, ahhh nope
  # vim # --> macOS ships vim
  # watch # --> do we use it ?
)

###############################################################################
# Networking / bench tools (can pull extra deps)                              #
###############################################################################

FORMULAE_NET=(
  #   httpie #--> replaced by xh
  xh
  httping
  siege
)

###############################################################################
# Optional “libraries” (often unnecessary unless you compile/link against them)
# Enable by running: INSTALL_LIBS=1 ./brew-setup.sh                            #
###############################################################################
FORMULAE_OPTIONAL_LIBS=(
  openssl
  openssh
  readline
)

###############################################################################
# Install                                                                      #
###############################################################################

log "Installing minimal formulae..."
for f in "${FORMULAE_MINIMAL[@]}"; do
  brew_install_safe "$f"
done

log "Installing shell add-ons..."
for f in "${FORMULAE_SHELL[@]}"; do
  brew_install_safe "$f"
done

log "Installing networking tools..."
for f in "${FORMULAE_NET[@]}"; do
  brew_install_safe "$f"
done

if [[ "${INSTALL_ZSH:-0}" == "1" ]]; then
  log "Installing optional: Homebrew zsh"
  for f in "${FORMULAE_OPTIONAL_SHELL[@]}"; do
    brew_install_safe "$f"
  done
fi

if [[ "${INSTALL_LIBS:-0}" == "1" ]]; then
  log "Installing optional libraries (openssl/openssh/readline)..."
  for f in "${FORMULAE_OPTIONAL_LIBS[@]}"; do
    brew_install_safe "$f"
  done
fi

###############################################################################

log "Cleaning up..."
brew cleanup

log "Done."
