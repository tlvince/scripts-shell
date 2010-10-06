#!/bin/sh

PACKAGES="$(pacman -Sl)"
REPOS="$(pacman -Sl | cut -f1 -d ' ' | uniq)"

echo "Total installed packages:"
for r in $REPOS; do
    total=$(echo "$PACKAGES" | grep "^$r")
    installed=$(echo "$PACKAGES" | grep "^$r.*\[installed\]")
    installedCount=$(echo "$installed" | wc -l)
    echo "$installed" | cut -f2 -d ' ' > "$r-$(date +"%F").txt"
    echo -n "$r: $installedCount"
    echo -n "/"
    echo "$total" | wc -l
done
