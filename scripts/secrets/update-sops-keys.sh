#!/bin/sh
set -eu

ROOT_PATH="$( cd -- "$(dirname "$0")/../.." >/dev/null 2>&1 ; pwd -P )"
pushd $ROOT_PATH
nix-shell -p sops --run "sops updatekeys secrets.yaml"
popd
