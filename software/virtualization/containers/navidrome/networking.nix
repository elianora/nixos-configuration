{ config, lib, ... }:

let
  any-user-has-navidrome-enabled = builtins.any (user: config.home-manager.users.${user}.software.virtualization.containers.navidrome.enable) (builtins.attrNames config.home-manager.users);
in
{
  config.networking.firewall.allowedTCPPorts = lib.optional any-user-has-navidrome-enabled 4533;
}
