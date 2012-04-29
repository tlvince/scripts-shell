#!/bin/bash
# sym: Symlink the canonical version(s) of $@ into $HOME/bin.
# Copyright 2010-2012 Tom Vincent <http://www.tlvince.com/>

usage() { echo "usage: ${0##*/} [file] -> ~/bin/[sanitised-symlink]"; exit; }

[[ $1 ]] || usage
[[ $1 = "-h" ]] || [[ $1 = "--help" ]] && usage

for i in "$@"; do
    full="$(readlink -f "$i")"  # Full canonical path
    file="${full##*/}"          # Basename
    file="${file%.*}"           # Strip extension
    ln -s "$full" "$HOME/bin/$file"
done

