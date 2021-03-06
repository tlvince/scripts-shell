#!/bin/sh
# Backup Twitter using the 't' gem.
# Copyright 2012 Tom Vincent <http://tlvince.com/contact>

t="${t:-$HOME/.gem/ruby/1.9.1/bin/t}"
out="${out:-$HOME/bak/twitter}"
user="${user:-@tlvince}"
count="${count:-3000}"

usage() { echo \
  [t=/path/to/t] [out=/path/to/backup/dir] [user=@twitterusername] [count=20] $0
  exit 1
}

[ "$@" ] && usage

mkdir -p "$out"

"$t" timeline "$user" --csv --number "$count" > "$out/tweets.csv"
"$t" retweets --csv --number "$count" > "$out/retweets.csv"
"$t" favorites --csv --number "$count" > "$out/favorites.csv"
"$t" direct_messages --csv --number "$count" > "$out/dm_received.csv"
"$t" direct_messages_sent --csv --number "$count" > "$out/dm_sent.csv"
"$t" followings --csv > "$out/followings.csv"
