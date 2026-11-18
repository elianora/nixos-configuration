{ config, lib, ... }:

let
  check-is-nextcloud-enabled = (username:
    config.system-settings.users.${username}.service-user.containers.postgres.enable &&
    config.system-settings.users.${username}.service-user.containers.redis.enable &&
    config.system-settings.users.${username}.service-user.containers.nextcloud.enable
  );

  nextcloud-enabled = builtins.any check-is-nextcloud-enabled (builtins.attrNames config.system-settings.users);
  podman-user = lib.findFirst check-is-nextcloud-enabled "root" (builtins.attrNames config.system-settings.users);
in
{
  config = lib.mkIf nextcloud-enabled {
    system.activationScripts.create-nextcloud-directories.text = ''
      create_podman_directory () {
        mkdir -p $3
        chown "''${1}:''${2}" $3
        chmod 0775 $3
        find "''${3}/" -type d -exec chmod 0775 {} +
        find "''${3}/" -type f -exec chmod 0664 {} +
      }

      create_podman_directory root service-users /srv/configuration
      create_podman_directory ${podman-user} service-users /srv/configuration/nextcloud
      create_podman_directory root service-users /srv/www
      create_podman_directory ${podman-user} service-users /srv/www/cloud.elianorarose.com
    '';

    systemd.tmpfiles.rules = [
      # SEE:
      # Permissions calc: https://linuxize.com/tools/chmod-calculator/
      # Tmpfiles format: https://www.man7.org/linux/man-pages/man5/tmpfiles.d.5.html
      ''v "/srv/configuration/nextcloud" 0775 ${podman-user} service-users''
      ''v "/srv/www/cloud.elianorarose.com" 0775 ${podman-user} service-users''
      ''z "/srv/configuration" 0775 root service-users''
      ''z "/srv/configuration/nextcloud" 0775 ${podman-user} service-users''
      ''z "/srv/www" 0775 root service-users''
      ''z "/srv/www/cloud.elianorarose.com" 0775 ${podman-user} service-users''
    ];
  };
}
