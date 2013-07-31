#!/bin/bash
# Split a CSV file to work within Excel's row limit.
# Copyright 2011 Tom Vincent <http://tlvince.com/contact>

die() { echo "$@" && exit 1; }

[[ $# == 0 ]] && die "$0 usage: [file].csv"

header="$(head -n 1 "$1")"
content="content.csv"
tail -n +2 "$1" > "$content"

# Excel 2003's limit is 65536 (-1 for header)
basename="${1%%.*}"
outdir="$basename-split"
mkdir -p "$outdir"
split -l 65535 "$content" "$outdir/$basename-"

# loop through the split files, adding the header and a '.csv' extension
for f in $outdir/*; do
  echo "$header" > "$f.csv"
  cat "$f" >> "$f.csv"
  rm "$f"
done

rm "$content"
