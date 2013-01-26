#!/bin/bash
# Has the sun risen?
# Copyright 2013 Tom Vincent <http://tlvince.com/contact>

[[ $1 ]] && [[ $2 ]] || { echo "$0 latitude longitude" && exit 1; }

times="$(sunwait -p $1 $2 | grep "Sun rises")"
riseset="${times//[^0-9,]/}"

# http://www.linuxjournal.com/article/8919
rise="${riseset%%,*}"
set="${riseset##*,}"
now="$(date +%H%M)"

# Convert to Unix timestamps
urise="$(date -d $rise +%s)"
uset="$(date -d $set +%s)"
unow="$(date -d $now +%s)"

[[ $unow -ge $urise && $unow -lt $uset ]] && echo true || echo false
