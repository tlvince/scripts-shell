#!/bin/bash
# Sanitise file and directory names.
# Copyright 2009, 2010 Tom Vincent <http://www.tlvince.com/contact/>

PATTERNS="
    s/[A-Z]*/\L&/g          # Replace uppercase with lowercase (\L&)
    s/ /-/g                 # Replace spaces
    s/[{}\(\)\\!',*+:$]//g  # Delete various special chars
    s/[\\d038]/-and-/g      # Replace the amperstad (ascii no 38 decimal)
    s/\\[//g                # XXX
    s/\\]//g                # XXX
    s/_/-/g                 # Replace underscores with dashes
    s/-\{2,\}/-/g           # Translate all series of dashes to just one dash
"

sanitise()
{
    dir="$(dirname "$1")"
    old="$(basename "$1")"
    new="$(echo $old | sed -e "$PATTERNS")"
    [[ "$old" != "$new" ]] && mv -iv "$dir/$old" "$dir/$new"
}

usage() { echo "usage: $0 [dir1] [dir2] ..."; exit 1; }

rdir()
{
    local dir

    while IFS='' read -d '' -r dir; do
        sanitise "$dir"
    done < <(find "$1" -depth -print0)
}

main()
{
    [[ $@ ]] || usage

    for arg in "$@"; do 
      if [[ -d "$arg" ]]; then
        rdir "$arg"
      elif [[ -e "$arg" ]]; then
        sanitise "$arg"
      else
        usage
      fi
    done
}

main "$@"
