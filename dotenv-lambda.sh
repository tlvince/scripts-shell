#!/usr/bin/env bash
set -euo pipefail

[[ -f ".env" ]] || exit 1

json="$(while IFS="=" read -r key value; do
  echo "\"$key\": \"$value\","
done < ".env")"

json="{\"Variables\": {${json::-1}} }"
name="$(jq -r '.name' package.json)"

aws lambda update-function-configuration \
  --function-name "$name" \
  --environment "$json"
