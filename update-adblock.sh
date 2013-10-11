#!/bin/sh
# Hosts file adblock update.
# © 2013 Tom Vincent <http://tlvince.com/contact>

VERBOSE=${VERBOSE:-true}
info() { $VERBOSE && echo "$0: $1"; }
tmp="$(mktemp /tmp/hosts.XXX)"

# Sources
mvps="http://winhelp2002.mvps.org/hosts.txt"
hphosts="http://hosts-file.net/download/hosts.txt"
danp="http://someonewhocares.org/hosts/hosts"
yoyo="http://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext"

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

head="/etc/hosts.head"
tail="/etc/hosts.tail"
[ -f "$head" ] && [ -f "$tail" ] || { rm "$tmp" && exit 1; }

info "Writing hosts"
cat "$head" "$tmp" "$tail" | sudo tee "/etc/hosts" >/dev/null

info "Updating DNS cache"
$osx && dscacheutil -flushcache
rm "$tmp"
