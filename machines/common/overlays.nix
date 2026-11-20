{ inputs, ... }:

{
  config.nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.pinned
    inputs.rust-overlay.overlays.default
  ];
}
