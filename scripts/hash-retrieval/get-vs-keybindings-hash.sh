#!/bin/sh
set -eu

## Version Settings
VS_KEYBINDINGS_VERSION="0.2.1"

## Hash Output
nix --extra-experimental-features nix-command store prefetch-file --hash-type sha256 --quiet --json https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-vscode/vsextensions/vs-keybindings/${VS_KEYBINDINGS_VERSION}/vspackage | jq -r .hash | xargs printf "sha256 = \"%s\";\n"
