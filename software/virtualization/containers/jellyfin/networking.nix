{ config, lib, ... }:

let
  any-user-has-jellyfin-enabled = builtins.any (user: config.home-manager.users.${user}.software.virtualization.containers.jellyfin.enable) (builtins.attrNames config.home-manager.users);
in
{
  config.networking.firewall = lib.mkIf any-user-has-jellyfin-enabled {
    allowedTCPPorts = [
      80
      443
      8096
    ];

    allowedUDPPortRanges = [
      { from = 7359; to = 7359; }
    ];
  };
}
