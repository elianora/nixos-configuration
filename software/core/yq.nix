{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.core.yq.enable = lib.mkEnableOption "Enable yq";
      config.home.packages = lib.optional config.software.core.jq.enable pkgs.yq-go;
    })
  ];
}
