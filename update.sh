#!/bin/sh
# Global system update script.
# Copyright 2009-2012 Tom Vincent <http://tlvince.com/contact>

_have() { which "$1" >/dev/null 2>&1; }

echo ":: Checking for new Arch Linux news entries..."
_have archnews && archnews
echo ":: Running pacman system upgrade..."
_have pacman && sudo pacman -Syu
echo ":: Dealing with pacnew and pacsave files..."
_have pacdiff && sudo pacdiff
echo ":: Running AUR system upgrade..."
_have raury && raury -Syu --devs --no-edit --no-confirm
echo ":: Updating dmenu cache..."
_have dmenu_path && dmenu_path >/dev/null
echo ":: Updating browser adblock user stylesheet..."
_have update-adblock && update-adblock
echo ":: Upgrading dwb extensions..."
_have dwbem && dwbem --upgrade
echo ":: Updating adblocking hosts file..."
_have hostsblock && sudo hostsblock
