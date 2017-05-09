#!/usr/bin/env bash
set -eo pipefail

[[ "$2" ]] || { echo "$0: <pass> <num> [num...]"; exit 1; }

pass="$(pass show "$1")"

for i in "${@:2}"; do
  echo "${pass:(i - 1):1}"
done

sleep 5
clear
