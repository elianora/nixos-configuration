{ config, lib, pkgs, ... }:

let
  any-user-has-steam-enabled = builtins.any (user: config.home-manager.users.${user}.software.games.steam.enable) (builtins.attrNames config.home-manager.users);
in
{
  config = {
    home-manager.sharedModules = [
      ({ lib, ... }: {
        options.software.games.steam.enable = lib.mkEnableOption "Enable Steam";
      })
    ];

    environment.systemPackages = lib.mkIf any-user-has-steam-enabled (with pkgs; [
      protonup-qt
      steam-devices-udev-rules
      steam-run
      steam-tui
    ]);

    hardware = lib.mkIf any-user-has-steam-enabled {
      steam-hardware.enable = true;
      wirelessRegulatoryDatabase = true;
    };

    programs = lib.mkIf any-user-has-steam-enabled {
      gamemode.enable = true;
      steam = {
        enable = true;
        extraPackages = with pkgs; [
          hidapi
        ];

        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        remotePlay.openFirewall = true;
      };
    };
  };
}
