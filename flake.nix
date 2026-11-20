{
  description = "Elianora Rose's NixOS Flake";

  inputs = {
    # nixpkgs (https://github.com/NixOS/nixpkgs)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # CachyOS kernel for NixOS (https://github.com/xddxdd/nix-cachyos-kernel)
    # NOTE: Do not override its nixpkgs input, otherwise there can be mismatch between patches and kernel version
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    # Home Manager (https://github.com/nix-community/home-manager)
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative Flatpaks (https://github.com/in-a-dil-emma/declarative-flatpak)
    flatpaks.url = "github:in-a-dil-emma/declarative-flatpak/v4.2.1";

    # NixOS Hardware Preconfigurations (https://github.com/NixOS/nixos-hardware)
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # KDE Plasma Manager (https://github.com/nix-community/plasma-manager)
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Rust Overlay (https://github.com/oxalica/rust-overlay)
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Scarlett2 Firmware (https://github.com/jakkunight/scarlett2-firmware-nix)
    scarlett2-firmware-nix = {
      url = "github:jakkunight/scarlett2-firmware-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # sops-nix Secret Management (https://github.com/Mic92/sops-nix)
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    flatpaks,
    home-manager,
    nixos-hardware,
    nixpkgs,
    sops-nix,
    ...
  }@inputs: {
    nixosConfigurations = {
      golden-torizo = nixpkgs.lib.nixosSystem {
        modules = [
          flatpaks.nixosModules.default
          home-manager.nixosModules.home-manager
          nixos-hardware.nixosModules.dell-xps-17-9700-nvidia
          sops-nix.nixosModules.sops
          ./machines/golden-torizo
        ];

        specialArgs = { inherit inputs; };
      };

      mother-brain = nixpkgs.lib.nixosSystem {
        modules = [
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          ./machines/mother-brain
        ];

        specialArgs = { inherit inputs; };
      };

      ridley = nixpkgs.lib.nixosSystem {
        modules = [
          flatpaks.nixosModules.default
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          ./machines/ridley
        ];

        specialArgs = { inherit inputs; };
      };
    };
  };
}
