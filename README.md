# Elianora Rose's NixOS Configuration

## About

This repository contains the NixOS configuration files for my devices.

## Before You Get Started

Before getting started, be sure to read [CODE_OF_CONDUCT.md](./CODE_OF_CONDUCT.md) and [CONTRIBUTING.md](./CONTRIBUTING.md), each of which contains guidelines that must be understood before working on this project. Note that these guidelines are merely for consistency with my other repositories.

## Building the Flake

To switch the OS to use the flake's resulting build, you can use the following command using `sudo` or `pkexec`: `nixos-rebuild switch --flake ./ --show-trace`.

If you'd like to include optional files that aren't added to the git repository, you'll need to add `path:` to the front of the location provided: `nixos-rebuild switch --flake path:./ --show-trace`.

If you use Visual Studio Code or Codium, you can use the tasks to run these commands automatically. The default build command tests that the system passes linting and builds, and other tasks actually run the `switch` command for you.

## Repository Structure

The flake modules are broken down into a few sections:

- [.hooks](./.hooks) contains a [pre-commit hook](./.hooks/pre-commit) that ensures the linting and building of the configuration must pass before a commit is made
- [Machines](./machines) contains a [common](./machines/common/default.nix) configuration that applies to all systems maintained by this configuration, and all other directories contain a machine-specific configuration
- [Scripts](./scripts) contains various helpers for writing Nix modules and/or testing the configuration
- [Software](./software/default.nix) contains all possible software that can be installed, and each file is made up of up to two parts:
    - The home-manager `config` uses `home-manager.sharedModules` so that any per-user configuration applies without effecting the system configuration
    - The system level `config` contains any necessary system-level software needed for user-level software to run properly
- [Users](./users/default.nix) contains all users present on any given system, with each user directory creating a user in the system and their personal configuration being within that directory
- [flake.nix](./flake.nix) is the root-level entrypoint for the configuration
- [.sops.yaml](./.sops.yaml) contains the `age` configuration that instructs `sops-nix` how to handle securing the secrets so that they aren't exposed to the public
- [secrets.yaml](./secrets.yaml) contains the secrets necessary for the system to run (done via `sops-nix`) without exposing them to the public

## References

### About Nix, Nixpkgs, and NixOS

The following reference was very helpful for me in understanding these concepts: [What is NixOS?](https://youtu.be/5D3nUU1OVx8?is=FlS03n-B9AJEMkpj).

### Secret Management

Secrets files are handled by [sops-nix](https://github.com/Mic92/sops-nix), which allows for the secrets to be securely committed to the repo for reproducibility without exposing them.

### Search Tools

These search tools are the primary ways for finding packages and scripts I've used thus far:

- [Nixpkgs Search](https://search.nixos.org/packages)
- [Noogle (Nix Function Search)](https://noogle.dev/)
- [Home Manager Packages](https://nix-community.github.io/home-manager/options/home-manager/programs/index.html)

### Other Documentation and Guides

The following references have been used heavily in creating this in addition to the previous sections:

- NixOS System Configuration
    - [NixOS with Flakes Guide](https://nixos-and-flakes.thiscute.world/introduction/)
    - [Packaging Unfree Assets with NixOS](https://www.midna.dev/posts/2023/08-19-packaging-a-commercial-font-with-nix.gmi)
    - [Using Limine to Set Up Secure Boot](https://wiki.nixos.org/wiki/Limine)
- Specific Hardware Configuration
    - [NixOS Hardware Preconfigurations](https://github.com/NixOS/nixos-hardware/tree/master)
    - [Scarlett2 Firmware](https://github.com/jakkunight/scarlett2-firmware-nix)
- [CachyOS Kernel for NixOS](https://github.com/xddxdd/nix-cachyos-kernel)
- ZFS
    - [ZFS on NixOS, High Level](https://www.return12.net/zfs-on-nixos/)
    - [ZFS on NixOS, Optimization](https://blog.tiserbox.com/posts/2024-02-09-zfs-on-nix-os.html)
- Podman/Docker
    - [Enabling Rootless Podman on NixOS (Incl. Steps Not in Official Wiki)](https://discourse.nixos.org/t/rootless-podman-setup-with-home-manager/57905)
    - [Docker Compose Setup for Nextcloud with Caddy (php-fpm)](https://help.nextcloud.com/t/nextcloud-docker-compose-setup-with-caddy-2026/204846)
- AppImage Support
    - [Using pre-build executables (NixOS manual)](https://nixos.org/manual/nixos/stable/#sec-custom-packages-prebuilt)
- Custom Derivations
    - [Proper mkDerivation](https://github.com/samdroid-apps/nix-articles/blob/master/04-proper-mkderivation.md)
    - [Tauri builds](https://nixos.org/manual/nixpkgs/unstable/#tauri-hook)

- Misc. Application Setup
    - [Fixing Obsidian (or other Electron Apps) to Not Create Two Icons in KDE](https://github.com/NixOS/nixpkgs/issues/505078#issuecomment-4167190319)
    - [Setting up KDE Connect on NixOS](https://nekomangini.github.io/post/setting-up-kdeconnect-on-nixos/)
    - [Building Tauri Applications on NixOS](https://nixos.org/manual/nixpkgs/stable/#tauri-hook)

Building and switching this repo to be used by NixOS can be done with `sudo nixos-rebuild switch --flake ~/path/to/repo`.
