{ config, lib, pkgs, ... }:

let
  any-user-has-podman-enabled = builtins.any (user: config.home-manager.users.${user}.software.virtualization.containers.enable) (builtins.attrNames config.home-manager.users);
in
{
  options.software.cockpit = {
    enable = lib.mkEnableOption "Enable Cockpit server manager";
    port = lib.mkOption {
      default = 9990;
      description = "The port to run the Cockpit instance through";
      type = lib.types.int;
    };
  };

  config.services.cockpit = lib.mkIf config.software.cockpit.enable {
    enable = true;
    allowed-origins = [
      "http://10.32.43.10:${toString config.software.cockpit.port}"
      "https://10.32.43.10:${toString config.software.cockpit.port}"
      "https://cockpit.elianorarose.com"
    ];

    openFirewall = true;
    plugins = (
      [ pkgs.cockpit-files ]
      ++ (lib.optional config.software.virtualization.kvm.enable pkgs.cockpit-machines)
      ++ (lib.optional any-user-has-podman-enabled pkgs.cockpit-podman)
    );

    port = config.software.cockpit.port;
    settings = {
      WebService = {
        AllowUnencrypted = true;
        ProtocolHeader = "X-Forwarded-Proto";
      };
    };
  };
}
