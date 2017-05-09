#!/bin/sh
# Hosts file adblock update.
# © 2013 Tom Vincent <http://tlvince.com/contact>

usage() { echo "[VERBOSE=true|false] [GIST_ID=ID] $0" && exit; }
[ "$1" = "-h" ] || [ "$1" = "--help" ] && usage

VERBOSE=${VERBOSE:-true}
info() { $VERBOSE && echo "$0: $1"; }
tmp="$(mktemp /tmp/hosts.XXX)"

# Sources
mvps="http://winhelp2002.mvps.org/hosts.txt"
hphosts="https://hosts-file.net/ad_servers.txt"
danp="http://someonewhocares.org/hosts/hosts"
yoyo="https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext"

for i in "$mvps" "$hphosts" "$danp" "$yoyo"; do
  info "Downloading '$i'"
  curl "$i" >> "$tmp"
done

PATTERNS="
  s/\r//                # Delete MS-DOS carriage returns
  s/\s+$//              # Delete trailing whitespace
  /^127.0.0.1/!d        # Delete all lines that don't begin with 127.0.0.1
  /local$/d             # Delete localhost lines (managed seperately)
  /localhost$/d         # Delete localhost lines (managed seperately)
  /localdomain$/d       # Delete localhost lines (managed seperately)
  s/127.0.0.1/0.0.0.0/  # Slight performance tweak
  s/\s\+/ /             # Collapse spaces
  s/#.*$//              # Delete comments
"

sed="sed"
[ "$(uname -s)" == "Darwin" ] && { osx=true; sed="gsed"; }

info "Processing hosts"
$sed -e "$PATTERNS" < "$tmp" | sort --unique --output="$tmp"

whitelist="/etc/hosts.whitelist"
[ -f "$whitelist" ] && {
  while read line; do
    $sed -i "/$line$/d" "$tmp"
  done < "$whitelist"
}

head="/etc/hosts.head"
tail="/etc/hosts.tail"
[ -f "$head" ] && [ -f "$tail" ] || { rm "$tmp" && exit 1; }

info "Writing hosts"
cat "$head" "$tmp" "$tail" | sudo tee "/etc/hosts" >/dev/null

[ "$GIST_ID" ] && {
  info "Backing up appendices to Gist"
  gist --update "$GIST_ID" "$tail"
}
