{ config, lib, pkgs, ... }:

let
  any-user-has-plasma-enabled = builtins.any (user: config.home-manager.users.${user}.software.desktop-environments.plasma.enable) (builtins.attrNames config.home-manager.users);
  any-user-has-kde-connect-enabled = builtins.any (user: config.home-manager.users.${user}.software.desktop-environments.plasma.kde-connect.enable) (builtins.attrNames config.home-manager.users);
in
{
  config = {
    home-manager.sharedModules = [
      ({ config, lib, pkgs, ... }: {
        options.software.desktop-environments.plasma = {
          enable = lib.mkEnableOption "Enable the KDE Plasma desktop environment";
          kde-connect.enable = lib.mkEnableOption "Enable KDE Connect";
        };

        config = lib.mkIf config.software.desktop-environments.plasma.enable {
          services.kdeconnect = lib.mkIf config.software.desktop-environments.plasma.kde-connect.enable {
            enable = true;
            package = pkgs.kdePackages.kdeconnect-kde;
            indicator = true;
          };

          programs.plasma = {
            enable = true;
            overrideConfig = true;
          };
        };
      })
    ];

    environment = lib.mkIf any-user-has-plasma-enabled {
      plasma6.excludePackages = with pkgs.kdePackages; [
        discover
        elisa
        kate
      ];

      # Default Chromium and Electron Apps to Wayland
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        XDG_SESSION_TYPE = "wayland";
      };

      systemPackages = with pkgs.kdePackages; [
        kalk
        krdc
        krfb
        plasma-browser-integration
        sddm-kcm
      ];
    };

    networking.firewall = lib.mkIf any-user-has-kde-connect-enabled rec {
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
        {
          from = 5900;
          to = 5900;
        }
      ];

      allowedUDPPortRanges = allowedTCPPortRanges;
    };

    services = lib.mkIf any-user-has-plasma-enabled {
      desktopManager.plasma6.enable = true;
      displayManager.sddm = {
        enable = true;
        enableHidpi = true;
        wayland.enable = true;
      };

      xserver = {
        enable = false;
      };
    };
  };
}
