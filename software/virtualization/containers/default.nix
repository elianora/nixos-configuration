{ config, lib, pkgs, ... }:

let
  any-user-has-podman-enabled = builtins.any (user: config.home-manager.users.${user}.software.virtualization.containers.enable) (builtins.attrNames config.home-manager.users);
in
{
  imports = [
    ./caddy
    ./jellyfin
    ./navidrome
  ];

  config = {
    home-manager.sharedModules = [
      ({ config, lib, pkgs, ... }: {
        options.software.virtualization.containers.enable = lib.mkEnableOption "Enable podman containers";
        config = lib.mkIf config.software.virtualization.containers.enable {
          services.podman = {
            enable = true;
            networks.hosted-applications = {
              driver = "bridge";
              subnet = "10.89.0.0/24";
            };
          };

          home.packages = with pkgs; [
            dive
            podman-compose
            podman-tui
          ];
        };
      })
    ];

    boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = lib.mkIf any-user-has-podman-enabled 80;
    environment.systemPackages = lib.optional any-user-has-podman-enabled pkgs.passt;
    systemd = lib.mkIf any-user-has-podman-enabled {
      services.dummy-wait-for-network = {
        description = "Dummy service to guarantee network is online for podman without causing build failures";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        serviceConfig = {
          ExecStart = ''${pkgs.coreutils}/bin/printf "This unit wants network-online.target"'';
          Type = "oneshot";
        };

        wantedBy = [ "multi-user.target" ];
      };

      user.extraConfig = ''
        DefaultEnvironment="PATH=/run/current-system/sw/bin:/run/wrappers/bin:${lib.makeBinPath [ pkgs.bash ]}"
      '';
    };

    virtualisation = lib.mkIf any-user-has-podman-enabled {
      containers.enable = true;
      oci-containers.backend = "podman";
      podman = {
        enable = true;
        autoPrune.enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };
  };
}
