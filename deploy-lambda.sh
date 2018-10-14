#!/usr/bin/env bash
set -euo pipefail

[[ -f "package.json" ]] || exit 1

tmp="$(mktemp -d)"
name="$(jq -r '.name' package.json)"

# shellcheck disable=2046
cp -r $(jq -r '.files[]' package.json) package.json "$tmp"

npm install --no-package-lock --prefix "$tmp" --production

(cd "$tmp" && zip -9 -r "$name.zip" .)

aws lambda update-function-code \
  --function-name "$name" \
  --zip-file "fileb://$tmp/$name.zip"

rm -rf "$tmp"
