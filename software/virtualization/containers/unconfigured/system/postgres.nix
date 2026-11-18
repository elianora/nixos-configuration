{ config, lib, ... }:

let
  postgres-enabled = (builtins.any (username: config.system-settings.users.${username}.service-user.containers.postgres.enable) (builtins.attrNames config.system-settings.users));
  podman-user = lib.findFirst (username: config.system-settings.users.${username}.service-user.containers.postgres.enable) "root" (builtins.attrNames config.system-settings.users);
in
{
  config = lib.mkIf (
    config.system-settings.server-environment.enable &&
    config.system-settings.server-environment.containers.enable &&
    postgres-enabled
  ) {
    networking.firewall.allowedTCPPorts = [ 5432 ];
    system.activationScripts.create-postgres-directories.text = ''
      create_podman_directory () {
        mkdir -p $3
        chown "''${1}:''${2}" $3
        chmod 0775 $3
        find "''${3}/" -type d -exec chmod 0775 {} +
        find "''${3}/" -type f -exec chmod 0664 {} +
      }

      create_podman_directory root service-users /srv/configuration
      create_podman_directory ${podman-user} service-users /srv/configuration/postgres
      create_podman_directory ${podman-user} service-users /srv/configuration/postgres/data

      if [ ! -f /srv/configuration/postgres/postgres.conf ]; then
        cp ${./postgres-defaults.conf} /srv/configuration/postgres/postgres.conf
        chown ${podman-user} /srv/configuration/postgres/postgres.conf
        chmod 0664 /srv/configuration/postgres/postgres.conf
      fi
    '';

    systemd.tmpfiles.rules = [
      # SEE:
      # Permissions calc: https://linuxize.com/tools/chmod-calculator/
      # Tmpfiles format: https://www.man7.org/linux/man-pages/man5/tmpfiles.d.5.html
      ''v "/srv/configuration/postgres" 0775 ${podman-user} service-users''
      ''v "/srv/configuration/postgres/data" 0775 ${podman-user} service-users''
      ''z "/srv/configuration/postgres" 0775 ${podman-user} service-users''
      ''z "/srv/configuration/postgres/data" 0775 ${podman-user} service-users''
      ''z "/srv/configuration" 0775 root service-users''
    ];
  };
}
