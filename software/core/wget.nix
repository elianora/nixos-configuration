{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.core.wget.enable = lib.mkEnableOption "Enable wget";
      config.home.packages = lib.optional config.software.core.wget.enable pkgs.wget;
    })
  ];
}
