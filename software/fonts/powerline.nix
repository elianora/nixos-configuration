{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.fonts.powerline.enable = lib.mkEnableOption "Enable Powerline fonts";
      config.home.packages = lib.optionals config.software.fonts.powerline.enable (with pkgs; [
        powerline-fonts
        powerline-symbols
      ]);
    })
  ];
}
