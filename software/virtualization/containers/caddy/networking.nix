{ config, lib, ... }:

let
  any-user-has-caddy-enabled = builtins.any (user: config.home-manager.users.${user}.software.virtualization.containers.caddy.enable) (builtins.attrNames config.home-manager.users);
in
{
  config.networking.firewall = lib.mkIf any-user-has-caddy-enabled {
    allowedTCPPorts = [
      80
      443
      2019
    ];

    allowedUDPPortRanges = [
      {
        from = 443;
        to = 443;
      }
    ];
  };
}
