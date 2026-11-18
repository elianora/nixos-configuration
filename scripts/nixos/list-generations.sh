#!/bin/sh
set -eu

sudo nix-env --profile /nix/var/nix/profiles/system --list-generations
