#!/bin/sh
# Boostrap a new Laravel site.
# © 2013 Tom Vincent <http://tlvince.com/contact>

vhosts="${vhosts:-/etc/apache2/extra/httpd-vhosts.conf}"
sites="${sites:-$HOME/sites}"

# Helpers
info() { echo "$0: $1"; }
error() { info "$1"; exit 1; }
usage() { echo "[vhosts] [sites] $0 [-h] site"; }

[ "$1" == "-h" ] && { usage && exit; }
[ -n "$1" ] || { usage && exit 1; }
site="$1"

grep -q "127.0.0.1.*$site$" "/etc/hosts" && error "$site host pre-exists"

cat << EOF | sudo tee -a "$vhosts" >/dev/null
<VirtualHost *:80>
  ServerName "$site"
  DocumentRoot "$sites/$site/public"
</VirtualHost>

EOF

echo "127.0.0.1 $site" | sudo tee -a "/etc/hosts" >/dev/null

# Set credentials in ~/.my.cnf
mysql -e \
  "create database $site; grant all privileges on $site.* to $site@localhost identified by '$site';"

sudo apachectl restart

open "http://$site/"
