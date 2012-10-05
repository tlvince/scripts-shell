#!/bin/dash
# pacman-ls.sh: List installed packages by repo.
# Copyright 2010-12 Tom Vincent <http://tlvince.com/contact>
# See also: paclist (community/pacman-contrib)

PACKAGES="$(pacman -Sl)"
REPOS="$(echo "$PACKAGES" | cut -f1 -d ' ' | uniq)"
OUT="${OUT:-$HOME/bak/packages}"
VERBOSE="${VERBOSE:-false}"

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

list="$(pacman -Qqm)"
echo "$list" > "$OUT/aur.txt"
$VERBOSE && echo "aur: $(echo "$list" | wc -l)"
