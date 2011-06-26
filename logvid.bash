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
error() { echo "${0##*/}: error: $@" >&2; exit 1; }

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

# Main {{{1
# Play the video
video="$(queue "${1:-.}")"
if [[ "$video" ]]; then
    mplayer -really-quiet "$video"

    # Get the user's rating of the video.
    #
    # 3 point scale, influenced by:
    # http://blog.viewfinder.io/
    #
    # -1 - Unrated
    #  0 - Good
    #  1 - Bad
    read -p "Rating: " rating
    if [[ "$rating" != 0 && "$rating" != 1 ]]; then
        rating=-1
    fi

    # Log both
    echo -e "${video##*/}\t$rating" >> "$watched"
fi

