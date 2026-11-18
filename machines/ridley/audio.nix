{ inputs, pkgs, ... }:

{
  config.hardware.firmware = [
    inputs.scarlett2-firmware-nix.packages.${pkgs.stdenv.hostPlatform.system}.scarlett2-firmware-nix
  ];
}
