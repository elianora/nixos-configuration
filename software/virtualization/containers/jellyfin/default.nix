{ ... }:

{
  imports = [
    ./files-and-directories.nix
    ./networking.nix
  ];

  config.home-manager.sharedModules = [
    ({ config, lib, ... }: {
      options.software.virtualization.containers.jellyfin = {
        enable = lib.mkEnableOption "Enables Jellyfin running as a podman container";
        gid = lib.mkOption {
          default = 100;
          description = ''The group ID to run the container as (defaults to "users")'';
          type = lib.types.int;
        };

        uid = lib.mkOption {
          default = config.home.uid;
          description = "The user ID to run the container as (defaults to current user's UID)";
          type = lib.types.int;
        };

        version = lib.mkOption {
          default = "latest";
          description = "Jellyfin container version";
          type = lib.types.str;
        };
      };

      config = lib.mkIf config.software.virtualization.containers.jellyfin.enable {
        assertions = [
          {
            assertion = config.software.virtualization.containers.enable;
            message = "Podman containers must be enabled to enable the Jellyfin container";
          }
        ];

        services.podman.containers.jellyfin-media-server = {
          image = "docker.io/jellyfin/jellyfin:${config.software.virtualization.containers.jellyfin.version}";
          addCapabilities = [
            "NET_ADMIN"
          ];

          autoStart = true;
          autoUpdate = "registry";
          description = "Jellyfin Media Server";
          extraPodmanArgs = [
            "--name=jellyfin-media-server"
            "--user=${toString config.software.virtualization.containers.jellyfin.uid}:${toString config.software.virtualization.containers.jellyfin.gid}"
            "--userns=keep-id"
          ];

          network = "hosted-applications";
          networkAlias = [
            "jellyfin"
            "jellyfin-media-server"
          ];

          ports = [
            "8096:8096"
            "7359:7359/udp"
          ];

          volumes = [
            "/srv/configuration/jellyfin/cache:/cache:Z"
            "/srv/configuration/jellyfin/config:/config:Z"
            "/srv/media/jellyfin:/media:Z"
          ];
        };
      };
    })
  ];
}
