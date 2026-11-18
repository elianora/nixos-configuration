{ config, lib, osConfig, ... }:

let
  gid = "100"; # The "users" group.
  nextcloud-enabled =
    osConfig.system-settings.server-environment.enable &&
    osConfig.system-settings.server-environment.containers.enable &&
    config.home.service-user.containers.postgres.enable &&
    config.home.service-user.containers.redis.enable &&
    config.home.service-user.containers.nextcloud.enable;

  uid = toString osConfig.system-settings.users.${config.home.username}.uid;
in
{
  config.services.podman.containers.nextcloud-server = lib.mkIf nextcloud-enabled {
    image = "docker.io/library/nextcloud:35-fpm";
    autoStart = true;
    autoUpdate = "registry";
    description = "Nextcloud Server";
    environment = {
      NEXTCLOUD_ADMIN_PASSWORD =  "${osConfig.sops.templates."nextcloud/password".content}";
      NEXTCLOUD_ADMIN_USER = "${osConfig.sops.templates."nextcloud/username".content}";
      NEXTCLOUD_INIT_HTACCESS = true;
      POSTGRES_DB = "Nextcloud";
      POSTGRES_HOST = "postgres";
      POSTGRES_PASSWORD = "${osConfig.sops.templates."postgres/password".content}";
      POSTGRES_USER = "${osConfig.sops.templates."postgres/username".content}";
      REDIS_HOST = "redis";
      REDIS_HOST_PORT = 6379;
      REDIS_HOST_PASSWORD = "${osConfig.sops.templates."redis/password".content}";
      REDIS_HOST_USER = "${osConfig.sops.templates."redis/username".content}";
      TRUSTED_PROXIES = "10.32.43.0/24 10.89.0.0/24";
    };

    extraConfig = {
      Unit = {
        After = "podman-postgres-database.service, podman-redis-cache.service";
      };
    };

    extraPodmanArgs = [
      "--name=nextcloud-server"
      "--user=${uid}:${gid}"
      "--userns=keep-id"
    ];

    network = "hosted-applications";
    networkAlias = [
      "nextcloud"
      "nextcloud-server"
    ];

    volumes = [
      "/srv/configuration/nextcloud:/var/www/html/config:Z"
      "/srv/www/cloud.elianorarose.com:/var/www/html:z"
    ];
  };
}
