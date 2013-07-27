#!/bin/bash
# Simple (reference) bookmarks.
# © 2013 Tom Vincent <http://tlvince.com/contact>

BOOKMARKS="${BOOKMARKS:-$HOME/.bookmarks}"

add() {
  read -p "URL: " url

  line="$(grep -n "^$url" "$BOOKMARKS" | cut -f1 -d:)"
  if [[ "$line" =~ ^[0-9]+$ ]]; then
    read -p "URL already bookmarked. Replace? " -n 1
    [[ ! $REPLY =~ ^[Yy]$ ]] && exit
    gsed -i "$line d" "$BOOKMARKS"
  fi

  read -p "Tags: " tags
  echo "$url $tags" >> "$BOOKMARKS"
}

search() {
  grep "$@" "$BOOKMARKS" | urlview
}

touch "$BOOKMARKS"
[[ $# -eq 0 ]] && add || search "$@"
