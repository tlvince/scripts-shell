#!/bin/sh
# Determine platform.
# © 2013 Tom Vincent <http://tlvince.com/contact>

os="/etc/os-release"
platform() { export PLATFORM="$0"; exit; }

[ "$(uname)" == "Darwin" ] && platform "Darwin"
[ -f "$os" ] && { grep -q "ID=arch" "$os" && platform "Arch"; }
