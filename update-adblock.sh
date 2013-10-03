#!/bin/sh
# Update adblock element hiding list.
# Copyright 2012 Tom Vincent <http://tlvince.com/contact>

adblock="https://www.fanboy.co.nz/adblock/opera/fanboy-adblocklist-elements-v4.css"

local="${XDG_LOCAL_HOME:-$HOME/.local/share}/adblock"
mkdir -p "$local"

curl -s "$adblock" > "$local/fanboy-element-hiding.css"
