#!/bin/sh
# Todo list manager.
# Copyright 2012 Tom Vincent <http://tlvince.com/contact/>

out=$HOME/doc/pim
[ -d "$out" ] || mkdir -p "$out"
todo="$out/do.txt"

[ $1 ] || { shuf -n 1 "$todo" && exit; }
echo $@ >> "$todo"
