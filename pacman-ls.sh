#!/bin/dash
# pacman-ls.sh: List installed packages by repo.
# Copyright 2010-12 Tom Vincent <http://tlvince.com/contact>
# See also: paclist (community/pacman-contrib)

usage() { echo "$0 [-v] out_dir" && exit 1; }

[ "$1" = "-v" ] && { verbose=true; shift; } || verbose=false
[ "$1" ] || usage

packages="$(pacman -Sl)"
repos="$(echo "$packages" | cut -f1 -d ' ' | uniq)"

out="$1"
mkdir -p "$out"

$verbose && echo "Total installed packages:"
  for repo in $repos; do
  list="$(echo "$packages" | grep "^$repo")"
  installed="$(echo "$list" | grep "\[installed\]")"
  echo "$installed" | cut -f2 -d ' ' > "$out/$repo.txt"
  $verbose && {
    echo "$repo: $(echo "$installed" | wc -l)/$(echo "$list" | wc -l)"
  }
done

list="$(pacman -Qqm)"
echo "$list" > "$out/aur.txt"
$verbose && echo "aur: $(echo "$list" | wc -l)"
