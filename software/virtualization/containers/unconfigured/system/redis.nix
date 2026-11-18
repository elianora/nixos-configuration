{ config, lib, ... }:

let
  podman-user = lib.findFirst (username: config.system-settings.users.${username}.service-user.containers.jellyfin.enable) "root" (builtins.attrNames config.system-settings.users);
in
{
  config = lib.mkIf (
    config.system-settings.server-environment.enable &&
    config.system-settings.server-environment.containers.enable &&
    (builtins.any (username: config.system-settings.users.${username}.service-user.containers.redis.enable) (builtins.attrNames config.system-settings.users))
  ) {
    networking.firewall.allowedTCPPorts = [ 6379 ];

    system.activationScripts.create-and-copy-redis-files.text = ''
      create_podman_directory () {
        mkdir -p $3
        chown "''${1}:''${2}" $3
        chmod 0775 $3
        find "''${3}/" -type d -exec chmod 0775 {} +
        find "''${3}/" -type f -exec chmod 0664 {} +
      }

      create_podman_directory root service-users /srv/configuration
      create_podman_directory ${podman-user} service-users /srv/configuration/redis
      create_podman_directory ${podman-user} service-users /srv/configuration/redis/data
      create_podman_directory ${podman-user} service-users /srv/configuration/redis/etc

      cat ${./redis.conf} > /srv/configuration/redis/etc/redis.conf
      echo "user default off nopass" >> /srv/configuration/redis/etc/redis.conf
      echo "user ''$(cat ${config.sops.secrets."redis/username".path}) on >''$(cat ${config.sops.secrets."redis/password".path}) ~* &* +@all" >> /srv/configuration/redis/etc/redis.conf
      chown ${podman-user} /srv/configuration/redis/etc/redis.conf
      chmod 0664 /srv/configuration/redis/etc/redis.conf
    '';

    systemd.tmpfiles.rules = [
      # SEE:
      # Permissions calc: https://linuxize.com/tools/chmod-calculator/
      # Tmpfiles format: https://www.man7.org/linux/man-pages/man5/tmpfiles.d.5.html
      ''v "/srv/configuration/redis" 0775 ${podman-user} service-users''
      ''v "/srv/configuration/redis/data" 0775 ${podman-user} service-users''
      ''v "/srv/configuration/redis/etc" 0775 ${podman-user} service-users''
      ''z "/srv/configuration/redis" 0775 ${podman-user} service-users''
      ''z "/srv/configuration/redis/data" 0775 ${podman-user} service-users''
      ''z "/srv/configuration/redis/etc" 0775 ${podman-user} service-users''
      ''z "/srv/configuration" 0775 root service-users''
    ];
  };
}
