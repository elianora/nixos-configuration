{ config, lib, osConfig, ... }:

let
  gid = "100";
  uid = toString osConfig.system-settings.users.${config.home.username}.uid;
in
{
  config.services.podman.containers.redis-cache = lib.mkIf (
    osConfig.system-settings.server-environment.enable &&
    osConfig.system-settings.server-environment.containers.enable &&
    config.home.service-user.containers.redis.enable
  ) {
    image = "docker.io/library/redis:8-trixie";
    autoStart = true;
    autoUpdate = "registry";
    description = "Redis Cache";
    exec = "redis-server /usr/local/etc/redis/redis.conf";
    extraPodmanArgs = [
      "--name=redis-cache"
      "--user=${uid}:${gid}"
      "--userns=keep-id"
    ];

    network = "hosted-applications";
    networkAlias = [
      "redis"
      "redis-cache"
    ];

    ports = [
      "6379:6379"
    ];

    volumes = [
      "/srv/configuration/redis/data:/data:Z"
      "/srv/configuration/redis/etc:/usr/local/etc/redis:Z"
    ];
  };
}
