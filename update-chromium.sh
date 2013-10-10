#!/bin/sh
# Update Chromium from the latest continuous build.
# © 2013 Tom Vincent <http://tlvince.com>

out="/opt/chromium"
url="https://commondatastorage.googleapis.com/chromium-browser-continuous"
curl="curl --location"

if [ "$(uname -s)" == "Darwin" ]; then
  url="$url/Mac"
  zip="chrome-mac.zip"
else
  exit 1
fi

rev="$($curl $url/LAST_CHANGE)"
[ "$rev" ] || exit 1

mkdir -p "$out"
$curl --output "$out/$zip" "$url/$rev/$zip"
[ -f "$out/$zip" ] || exit 1
[ -d "$out/chrome-mac" ] && rm -rf "$out/chrome-mac"
unzip -d "$out" "$out/$zip"
rm "$out/$zip"

ln -s "$out/chrome-mac/Chromium.app" "$HOME/Applications"
