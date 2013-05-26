#!/bin/bash
# sym: Symlink the canonical version(s) of $@ into $HOME/bin.
# Copyright 2010-2013 Tom Vincent <http://tlvince.com/contact>

usage() {
  echo "usage: [BIN=$bin] ${0##*/} file -> $bin/{sanitised-symlink}"
  exit
}

bin="${BIN:-$HOME/bin}"
[[ $1 ]] || usage
[[ $1 = "-h" ]] || [[ $1 = "--help" ]] && usage
[[ -d "$bin" ]] || mkdir -p "$bin"

# brew install coreutils
readlink="readlink"; [[ $(uname) = "Darwin" ]] && readlink="g$readlink"

for i in "$@"; do
  full="$($readlink -f "$i")" # Full canonical path
  file="${full##*/}"          # Basename
  file="${file%.*}"           # Strip extension
  ln -s "$full" "$bin/$file"
done
