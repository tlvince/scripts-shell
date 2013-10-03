#!/bin/sh
# Single instance Vim.
# Copyright 2012 Tom Vincent <http://tlvince.com/contact>

if vim --serverlist | grep -q "VIM"; then
  for i in "$@"; do
    vim --remote-send ":split $(readlink -f "$i")<cr>"
  done
else
  vim --servername VIM "$@"
fi
