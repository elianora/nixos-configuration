#!/bin/sh
set -eu

## Version Settings
RIDER_VERSION="2026.3.0.2"

## Hash Output
nix --extra-experimental-features nix-command store prefetch-file --hash-type sha256 --quiet --json https://download.jetbrains.com/rider/JetBrains.Rider-${RIDER_VERSION}.tar.gz | jq -r .hash | xargs printf "(x86_64-linux) hash = \"%s\";\n"
nix --extra-experimental-features nix-command store prefetch-file --hash-type sha256 --quiet --json https://download.jetbrains.com/rider/JetBrains.Rider-${RIDER_VERSION}-aarch64.tar.gz | jq -r .hash | xargs printf "(aarch64-linux) hash = \"%s\";\n"
nix --extra-experimental-features nix-command store prefetch-file --hash-type sha256 --quiet --json https://download.jetbrains.com/rider/JetBrains.Rider-${RIDER_VERSION}.dmg | jq -r .hash | xargs printf "(x86_64-darwin) hash = \"%s\";\n"
nix --extra-experimental-features nix-command store prefetch-file --hash-type sha256 --quiet --json https://download.jetbrains.com/rider/JetBrains.Rider-${RIDER_VERSION}-aarch64.dmg | jq -r .hash | xargs printf "(aarch64-darwin) hash = \"%s\";\n"
