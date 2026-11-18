{ config, lib, ... }:

let
  any-user-has-plasma-enabled = builtins.any (user: config.home-manager.users.${user}.software.desktop-environments.plasma.enable) (builtins.attrNames config.home-manager.users);
in
{
  imports = [
    ./monochrome-sddm-theme.nix
  ];

  config = lib.mkIf any-user-has-plasma-enabled {
    environment.systemPackages = [
      config.custom-packages.monochrome-sddm-theme
    ];

    services.displayManager.sddm = {
      theme = "Monochrome Plasma 6";
      extraPackages = [
        config.custom-packages.monochrome-sddm-theme
      ];
    };
  };
}
