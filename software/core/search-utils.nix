{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.core.search-utils.enable = lib.mkEnableOption "Enable search utilities";
      config.home.packages = lib.optionals config.software.core.search-utils.enable (with pkgs; [
        file
        findutils
        tree
        which
      ]);
    })
  ];
}
