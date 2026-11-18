{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.fonts.liberation.enable = lib.mkEnableOption "Enable Liberation fonts";
      config.home.packages = lib.optionals config.software.fonts.liberation.enable (with pkgs; [
        liberation_ttf
      ]);
    })
  ];
}
