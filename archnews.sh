#!/bin/sh
# archnews: download and view the latest Arch Linux news entry. {{{1
# Copyright 2012 Tom Vincent <http://tlvince.com/contact>
# vim: fdm=marker

# Initialisation {{{1
have()  { which "$1" >/dev/null 2>&1; }
info()  { echo "$0: $1"; }
error() { info "$1" >&2 && exit 1; }

feed="${feed:-https://www.archlinux.org/feeds/news/}"
cache="${cache:-${XDG_CACHE_HOME:-$HOME/.cache}/archnews}"
entry="${entry:-$cache/latest-entry.html}"
BROWSER="${BROWSER:-less}"
lastran="${lastran:-$cache/lastran}"
news_xml="${news_xml:-$cache/news.xml}"
news_html="${news_html:-$cache/news.html}"

[ -d "$cache" ]  || mkdir -p "$cache"
have "xmllint"   || error "xmllint(1) required"
have "recode"    || error "recode(1) required"

# Main {{{1
curl="curl --silent --url $feed --output $news_xml"
[ -f "$lastran" ] && ran_date="$(head -n1 "$lastran")"
[ "$ran_date" ] && $curl --time-cond "$ran_date" || $curl

build_date="$(xmllint --xpath "/rss/channel/lastBuildDate/text()" "$news_xml")"
unix_build_date="$(date --date "$build_date" +%s)"

if [ "$ran_date" ]; then
  if [ "$unix_build_date" -gt "$(date --date "$ran_date" +%s)" ]; then
    xmllint --xpath "/rss/channel/item[1]/description/text()" "$news_xml" | \
      recode HTML_4.0 > "$entry"
    "$BROWSER" "$entry" >/dev/null 2>&1
  fi
else
  xmllint --htmlout "$news_xml" 2>&1 | recode HTML_4.0 > "$news_html"
  "$BROWSER" "$news_html" >/dev/null 2>&1
fi

date --rfc-2822 > "$lastran"
