{ config, lib, pkgs, ... }:

let
  any-user-has-desktop-environments-enabled = builtins.any (user: config.home-manager.users.${user}.software.desktop-environments.plasma.enable) (builtins.attrNames config.home-manager.users);
in
{
  options.printing.enable = lib.mkEnableOption "Enable print services";
  config = lib.mkIf config.printing.enable {
    environment.systemPackages = lib.mkIf any-user-has-desktop-environments-enabled (with pkgs; [
      (epsonscan2.override {
        withNonFreePlugins = true;
        withGui = true;
      })
    ]);

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    services.ipp-usb.enable = true;
    services.printing = {
      enable = true;
      drivers = with pkgs; [
        cups-browsed
        cups-filters
        epson-escpr
        epson-escpr2
      ];
    };
  };
}
