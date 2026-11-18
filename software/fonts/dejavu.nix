{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.fonts.dejavu.enable = lib.mkEnableOption "Enable DejaVu fonts";
      config.home.packages = lib.optionals config.software.fonts.dejavu.enable (with pkgs; [
        dejavu_fonts
      ]);
    })
  ];
}
