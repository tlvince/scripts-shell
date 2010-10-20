#!/bin/sh
#
# pacman-ls.sh: List installed packages by repo.
#
# Copyright 2010 Tom Vincent <http://www.tlvince.com/contact/>

PACKAGES="$(pacman -Sl)"
REPOS="$(echo "$PACKAGES" | cut -f1 -d ' ' | uniq)"
OUT="$HOME/bak/packages"
VERBOSE=true

mkdir -p "$OUT"

$VERBOSE && echo "Total installed packages:"
for repo in $REPOS; do
    list="$(echo "$PACKAGES" | grep "^$repo")"
    installed="$(echo "$list" | grep "\[installed\]")"
    echo "$installed" | cut -f2 -d ' ' > "$OUT/$repo.txt"
    $VERBOSE && {
        echo "$repo: $(echo "$installed" | wc -l)/$(echo "$list" | wc -l)"
    }
done
