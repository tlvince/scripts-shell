#!/bin/sh
# Global system update script.
# © 2009-2013 Tom Vincent <http://tlvince.com/contact>

_info() { echo ":: $1..."; }
_have() { which "$1" >/dev/null 2>&1; }
_error() { echo "$1"; exit 1; }

_have platform || error "Can't determine platform"
case "$PLATFORM" in
  "Arch")
    _info "Checking for new Arch Linux news entries"
    _have archnews && archnews
    _info "Running pacman system upgrade"
    _have pacman && sudo pacman -Syu
    _info "Dealing with pacnew and pacsave files"
    _have pacdiff && sudo pacdiff
    _info "Running AUR system upgrade"
    _have raury && raury -Syu --devs --no-edit --no-confirm
    _info "Updating dmenu cache"
    _have dmenu_path && dmenu_path >/dev/null
    _info "Updating browser adblock user stylesheet"
    _have update-adblock && update-adblock
    _info "Upgrading dwb extensions"
    _have dwbem && dwbem --upgrade
    _info "Updating adblocking hosts file"
    _have hostsblock && sudo hostsblock
  ;;
  "Darwin")
    _info "Running softwareupdate system upgrade"
    _have softwareupdate && sudo softwareupdate -ia
    _info "Updating homebrew"
    _have brew && { brew update; brew upgrade; brew cleanup; }
    _info "Updating homebrew-cask"
    _have update-cask && update-cask
    _info "Updating global npm packages"
    _have npm && { npm update -g npm; npm update -g; }
    _info "Updating Ruby gems"
    _have gem && sudo gem update
    _info "Updating Chromium"
    _have update-chromium && update-chromium
    _info "Updating adblocking hosts files"
    _have update-adblock && update-adblock
  ;;
esac

