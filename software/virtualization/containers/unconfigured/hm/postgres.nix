{ config, lib, osConfig, ... }:

let
  gid = "100"; # The "users" group.
  uid = toString osConfig.system-settings.users.${config.home.username}.uid;
in
{
  config.services.podman.containers.postgres-database = lib.mkIf (
    osConfig.system-settings.server-environment.enable &&
    osConfig.system-settings.server-environment.containers.enable &&
    config.home.service-user.containers.postgres.enable
  ) {
    image = "docker.io/library/postgres:18-trixie";
    autoStart = true;
    autoUpdate = "registry";
    description = "PostgreSQL Database";
    environment = {
      POSTGRES_DB = "postgres";
      POSTGRES_PASSWORD_FILE = "/run/secrets/password";
      POSTGRES_USER_FILE = "/run/secrets/username";
    };

    extraPodmanArgs = [
      "--name=postgres-database"
      "--user=${uid}:${gid}"
      "--userns=keep-id"
    ];

    network = "hosted-applications";
    networkAlias = [
      "postgres"
      "postgres-database"
    ];

    ports = [
      "5432:5432"
    ];

    volumes = [
      "/srv/configuration/postgres/data:/var/lib/postgresql:Z"
      "/srv/configuration/postgres/postgres.conf:/etc/postgressql/postgresql.conf:Z"
      "${osConfig.sops.secrets."postgres/password".path}:/run/secrets/password:Z,ro"
      "${osConfig.sops.secrets."postgres/username".path}:/run/secrets/username:Z,ro"
    ];
  };
}
