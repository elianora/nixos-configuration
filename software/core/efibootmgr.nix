{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.core.efibootmgr.enable = lib.mkEnableOption "Enable efibootmgr";
      config.home.packages = lib.optional config.software.core.efibootmgr.enable pkgs.efibootmgr;
    })
  ];
}
