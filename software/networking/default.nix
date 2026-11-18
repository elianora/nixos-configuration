{ ... }:

{
  imports = [
    ./openssh.nix
    ./winbox
  ];

  config = {
    home-manager.sharedModules = [
      ({ config, lib, pkgs, ... }: {
        config.home.packages = lib.optionals config.service-user (with pkgs; [
          dnsutils
          ethtool
          iftop
          iw
          lsof
          nmap
          traceroute
        ]);
      })
    ];

    networking.networkmanager.enable = true;
  };
}
