#!/bin/sh
# Toggle hosts file.
# © 2014 Tom Vincent <http://tlvince.com/contact>

hosts="${HOSTS:-/etc/hosts}"
[ -f "$hosts" ] && sudo mv -v "$hosts"{,~} || sudo mv -v "$hosts"{~,}
