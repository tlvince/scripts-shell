#!/bin/sh
# Title:    clean-name.sh
# Author:   Tom Vincent
# Created:  0.3.0 (2009-09-15)
# Updated:  0.3.1 (2010-03-23)
#
# A script to rename files and directories following a pattern.
# Based on "renamer" by pbrisbin (http://pbrisbin.com:8080/bin/renamer) and
# help from gnud and Cerebral
# (http://bbs.archlinux.org/viewtopic.php?pid=621096#p621096)

PATTERNS="
    s/[A-Z]*/\L&/g          # Replace uppercase with lowercase (\L&)
    s/ /-/g                 # Replace spaces
    s/[{}\(\)\\!',*]//g      # Delete some special chars
    s/[\\d038]/-and-/g      # Replace the amperstad (ascii no 38 decimal)
    s/_/-/g                 # Replace underscores with dashes
    s/-\{2,\}/-/g           # Translate all series of dashes to just one dash
"

message() {
  echo "usage: renamer [dir1] [dir2] ..."
  echo
  exit 1
}

renameit() {
    dir=$(dirname "$1")
    old=$(basename "$1")
    new=$(echo $old | sed -e "$PATTERNS")

    [ "$old" != "$new" ] && mv -iv "$dir/$old" "$dir/$new"

}

[ $# -lt 1 ] && message

# can pass mixture of dirs and files
# files are changed in basename
# dirs are changed recursively
for arg in "$@"; do
  if [ -d "$arg" ]; then
    find "$arg" -depth | while read dir; do
      renameit "$dir"
    done
  else
    renameit "$arg"
  fi
done
