#!/bin/sh
# Boostrap a new Laravel site.
# © 2013 Tom Vincent <http://tlvince.com/contact>

# Helpers
info() { echo "$0: $1"; }
error() { info "$1"; exit 1; }
usage() { echo "$0 [-h] site"; }

[ "$1" == "-h" ] && { usage && exit; }
[ -n "$1" ] || { usage && exit 1; }
site="$1"

grep -q "127.0.0.1.*$site$" "/etc/hosts" && error "$site vhost pre-exists"

vhosts="/etc/apache2/extra/httpd-vhosts.conf"
cat << EOF | sudo tee -a "$vhosts" >/dev/null
<VirtualHost *:80>
  ServerName "$site"
  DocumentRoot "/Users/tom/Sites/$site/public"
</VirtualHost>

EOF

echo "127.0.0.1 $site" | sudo tee -a "/etc/hosts" >/dev/null

# Set credentials in ~/.my.cnf
mysql -e \
  "create database $site; grant all privileges on $site.* to $site@localhost identified by '$site';"

sudo apachectl restart

open "http://$site/"
