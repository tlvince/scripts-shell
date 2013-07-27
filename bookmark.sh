#!/bin/bash
# Simple (reference) bookmarks.
# © 2013 Tom Vincent <http://tlvince.com/contact>

BOOKMARKS_DIR="${BOOKMARKS_DIR:-$HOME/.bookmarks}"
BOOKMARKS="$BOOKMARKS_DIR/bookmarks.txt"

export GIT_DIR="$BOOKMARKS_DIR/.git"
export GIT_WORK_TREE="$BOOKMARKS_DIR"

_prompt() {
  read -p "$1 [y/n] "
  [[ $REPLY =~ ^[Yy]$ ]] || exit
}

_commit() {
  git add "$BOOKMARKS"
  git commit "$BOOKMARKS" --message "$1"
}

add() {
  read -p "URL: " url

  line="$(grep -n "^$url" "$BOOKMARKS" | cut -f1 -d:)"
  if [[ "$line" =~ ^[0-9]+$ ]]; then
    _prompt "URL already bookmarked. Replace?"
    gsed -i "$line d" "$BOOKMARKS"
    message="Replaced"
  else
    message="Added"
  fi

  read -p "Tags: " tags
  echo "$url $tags" >> "$BOOKMARKS"
  _commit "$message $url"
}

search() {
  grep -i "$@" "$BOOKMARKS" | urlview
}

[[ -d "$BOOKMARKS_DIR" ]] || mkdir -p "$BOOKMARKS_DIR"
[[ -d "$GIT_DIR" ]] || git init
touch "$BOOKMARKS"
[[ $# -eq 0 ]] && add || search "$@"
