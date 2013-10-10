#!/bin/bash
# Update cask's.
# https://github.com/phinze/homebrew-cask/issues/309#issuecomment-17972519

brew cask >/dev/null 2>&1 && { [ $? -eq 0 ] || exit 1; }

caskApps=$(ls /opt/homebrew-cask/Caskroom/)
for app in $caskApps; do
  appToCheck=$(brew cask list | grep "$app")
  if [[ -z "$appToCheck" ]]; then
    brew cask install --force "$app"
  fi
done
