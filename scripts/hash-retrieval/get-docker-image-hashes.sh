#!/bin/sh
set -eu
read -p "Enter the image name without tags (prefix with the relevant registry path if not using docker.io): " DOCKER_IMAGE_NAME
read -p "Enter the image tag: " DOCKER_IMAGE_TAG
nix run nixpkgs#nix-prefetch-docker -- --image-name $DOCKER_IMAGE_NAME --image-tag $DOCKER_IMAGE_TAG
