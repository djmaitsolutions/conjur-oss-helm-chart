#!/bin/bash

prune_version() {
  local version
  version=$(<VERSION)
  echo "${version%%-*}"
}

if [ -f VERSION ]; then
  NEW_VERSION=$(prune_version)
else
  NEW_VERSION="0.0.0-dev"
fi

CHART_FILE="conjur-oss/Chart.yaml"

# Update the Chart version field
sed -i.bak "s/^version: .*/version: $NEW_VERSION/" "$CHART_FILE"

echo "Updated version to $NEW_VERSION in $CHART_FILE"

rm -rf package
mkdir -p package

docker run --rm -v "$(pwd):/workdir" -w /workdir alpine/helm package --destination ./package ./conjur-oss
