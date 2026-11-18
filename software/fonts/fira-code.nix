{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.fonts.fira-code.enable = lib.mkEnableOption "Enable Fira Code fonts";
      config.home.packages = lib.optionals config.software.fonts.fira-code.enable (with pkgs; [
        fira-code
        fira-code-symbols
      ]);
    })
  ];
}
