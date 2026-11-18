{ inputs, ... }:

{
  config.nixpkgs.overlays = [
    inputs.rust-overlay.overlays.default
  ];
}
