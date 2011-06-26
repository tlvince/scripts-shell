#!/bin/bash
# Log videos watched and their rating. {{{1
# Copyright 2011 Tom Vincent <http://www.tlvince.com/contact/>
# vim: set fdm=marker:

# Environment {{{1
data_home="${XDG_DATA_HOME:-$HOME/.local/share}/logvid"
mkdir -p "$data_home"
watched="$data_home/watched.txt"
touch "$watched"

# Helper functions {{{1
info() { echo "${0##*/}: $@"; }
error() { info "error: $@" >&2; exit 1; }
usage() { echo "usage: ${0##*/} [-h] [path]"; }

# Find an unwatched video. {{{1
#
# $1 - A directory path.
# $2 - The previously found filename.
#
# Returns the absolute path to the video.
queue() {
    # XXX: Store the results of find for subsequent searches
    next="$(find "$1" -type f | shuf -n 1)"
    [[ "$next" = "$2" ]] && error "No more videos to watch"
    grep -q "${next##*/}" "$watched" && queue "$1" "$next"
    echo "$next"
}

# Get the user's rating of the video. {{{1
#
# 2 point scale, influenced by:
# http://blog.viewfinder.io/
#
# A rating is either:
#
#  0 - Good
#  1 - Bad
#
# Returns a rating, otherwise null.
rating() {
    read -p "${0##*/}: rating: " rating
    if [[ "$rating" = 0 || "$rating" = 1 ]]; then
        echo "$rating"
    fi
}

# Main {{{1

# Parse options
case "$1" in -h|--help) usage; exit;; esac

# Queue a video
video="$(queue "${1:-.}")"
if [[ "$video" ]]; then
    # Play the video
    info "playing: ${video##*/}"
    mplayer -really-quiet -fs "$video"

    # Rate the video
    rating="$(rating)"
    if [[ "$rating" ]]; then
        # Log both
        echo -e "${video##*/}\t$rating" >> "$watched"
    fi
fi

