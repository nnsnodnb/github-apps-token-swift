#!/bin/bash -eu

swift build --disable-sandbox -c release --arch arm64 --arch x86_64

BIN_PATH=$(swift build --show-bin-path -c release --arch x86_64 --arch arm64)/github-apps-token

VERSION=$(${BIN_PATH} --version)

rm -rf GitHubAppsToken.artifactbundle
mkdir -p GitHubAppsToken.artifactbundle/bin
cp ${BIN_PATH} GitHubAppsToken.artifactbundle/bin/
cp ./LICENSE GitHubAppsToken.artifactbundle

jq -n \
  --arg version "$(echo ${VERSION})" \
  --arg type "executable" \
  --arg path "bin/github-apps-token" \
  -f ./scripts/info.jq \
  | tee GitHubAppsToken.artifactbundle/info.json

zip -r GitHubAppsToken.artifactbundle.zip GitHubAppsToken.artifactbundle

swift package compute-checksum GitHubAppsToken.artifactbundle.zip
