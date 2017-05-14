#!/usr/bin/env bash
set -euo pipefail

declare -i last_called=0
declare -i throttle_by=1

# https://gist.github.com/niieani/29a054eb29d5306b32ecdfa4678cbb39
throttle() {
  local -i now=$(date +%s)
  (($now - $last_called >= $throttle_by)) && "$@"
  last_called=$(date +%s)
}

[[ "$#" -gt 2 ]] || { echo "$0: <src> <cmd>"; exit 1; }

# https://vi.stackexchange.com/q/4038
inotifywait -mrq -e CREATE --exclude 4913 "$1" | while read; do throttle "${@:2}"; done
