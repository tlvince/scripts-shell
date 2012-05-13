#!/bin/dash
# Toggle an SSH tunnel to the given host, optionally starting [cmd] with SOCKS.
# Copyright 2012 Tom Vincent <http://tlvince.com/contact/>

app="tunnel"
info() { echo "$app: $1"; }
error() { info "$1" >&2 && exit 1; }
usage() { echo "usage: $app host [cmd port]"; exit 1; }

[ $1 ] || usage

port=${3:-4711}
tunnel="ssh -fND $port $1"

pid=$(pgrep -f "$tunnel")
[ $pid ] && kill $pid && info "killed existing tunnel to '$1'" && exit

$tunnel && info "tunnelled to '$1' on port '$port'" || error "tunnel failed"

[ $2 ] && {
    export SOCKS_SERVER=localhost:$port
    export SOCKS_VERSION=5
    $2 >/dev/null 2>&1
}
