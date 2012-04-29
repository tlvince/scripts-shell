#!/bin/bash
# Open files based on their mime type.
# Copyright 2010 Patrick Brisbin
# Copyright 2012 Tom Vincent <http://tlvince.com/contact/>

# Helper functions. {{{1
app="${0##*/}"
info() { echo "$app: $1"; }
error() { echo "$app: $1" >&2 && exit 1; }
have() { which "$1" >/dev/null 2>&1; }

[[ $1 ]] || error "argument required"

[[ -f "$1" ]] || {
  info "'$1' is not a file, trying \$BROWSER"
  $BROWSER "$1" &>/dev/null & exit
}

have "xdg-mime" || error "xdg-mime required"

# read the major and minor mimetype
IFS='/' read -r major minor < <(xdg-mime query filetype "$1" 2>/dev/null | cut -d ';' -f 1)

# check for a specific case
case "$major/$minor" in
  text/html)       $BROWSER "$1" &>/dev/null & exit ;;
  application/pdf) zathura "$1"  &>/dev/null & exit ;;
esac

# check for just a major match
case "$major" in
  image) feh "$1"           &>/dev/null & exit ;;
  audio) mplayer "$1"       &>/dev/null & exit ;;
  text)  urxvtc -e vim "$1" &>/dev/null & exit ;;
  video) mplayer "$1"       &>/dev/null & exit ;;
esac

error "$1: unmatched on mimetype"
