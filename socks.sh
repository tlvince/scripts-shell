#!/bin/sh
# Start a transparent socks session.
# Copyright 2012 Tom Vincent <http://tlvince.com/contact/>

app="socks"
info() { echo "$app: $1"; }
error() { info "$1" >&2 && exit 1; }
usage() { echo "usage: $app host [cmd port]"; exit 1; }

[ $1 ] || usage

tunnel="tunnel $*"

# Stop
[ -f /run/redsocks/redsocks.pid ] && {
  info "killing existing socks proxy to '$1'"
  $tunnel
  sudo systemctl stop redsocks.service
  sudo systemctl restart iptables.service
  exit
}

# Start
info "starting socks proxy to '$1'"
$tunnel
sudo systemctl start redsocks.service
sudo iptables-restore /etc/iptables/redsocks.rules
