{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.core.nix-utils.enable = lib.mkEnableOption "Enable nix utilities";
      config.home.packages = lib.optional config.software.core.nix-utils.enable pkgs.nix-output-monitor;
    })
  ];
}
