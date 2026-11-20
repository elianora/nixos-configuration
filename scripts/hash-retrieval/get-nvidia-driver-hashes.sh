#!/bin/sh
set -eu

## Version Settings
NVIDIA_DRIVER_VERSION="620.73.04"

## Hash Output
printf "version = \"${NVIDIA_DRIVER_VERSION}\";\n"
nix --extra-experimental-features nix-command store prefetch-file --hash-type sha256 --quiet --json https://download.nvidia.com/XFree86/Linux-x86_64/${NVIDIA_DRIVER_VERSION}/NVIDIA-Linux-x86_64-${NVIDIA_DRIVER_VERSION}.run | jq -r .hash | xargs printf "sha256_64bit = \"%s\";\n"
nix --extra-experimental-features nix-command store prefetch-file --hash-type sha256 --quiet --json https://download.nvidia.com/XFree86/Linux-aarch64/${NVIDIA_DRIVER_VERSION}/NVIDIA-Linux-aarch64-${NVIDIA_DRIVER_VERSION}.run | jq -r .hash | xargs printf "sha256_aarch64 = \"%s\";\n"
nix --extra-experimental-features nix-command store prefetch-file --hash-type sha256 --quiet --json --unpack https://github.com/NVIDIA/open-gpu-kernel-modules/archive/refs/tags/${NVIDIA_DRIVER_VERSION}.tar.gz | jq -r .hash | xargs printf "openSha256 = \"%s\";\n"
nix --extra-experimental-features nix-command store prefetch-file --hash-type sha256 --quiet --json --unpack https://github.com/NVIDIA/nvidia-settings/archive/refs/tags/${NVIDIA_DRIVER_VERSION}.tar.gz | jq -r .hash | xargs printf "settingsSha256 = \"%s\";\n"
nix --extra-experimental-features nix-command store prefetch-file --hash-type sha256 --quiet --json --unpack https://github.com/NVIDIA/nvidia-persistenced/archive/refs/tags/${NVIDIA_DRIVER_VERSION}.tar.gz | jq -r .hash | xargs printf "persistencedSha256 = \"%s\";\n"
