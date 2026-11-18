#!/bin/sh
set -eu

mkdir -p ~/.config/sops/age

ROOT_PATH="$( cd -- "$(dirname "$0")/../.." >/dev/null 2>&1 ; pwd -P )"
pushd $ROOT_PATH
nix-shell -p ssh-to-age --run "sudo ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key > ~/.config/sops/age/keys.txt"
popd
