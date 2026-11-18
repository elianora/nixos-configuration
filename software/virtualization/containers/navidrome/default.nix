{ ... }:

{
  imports = [
    ./files-and-directories.nix
    ./networking.nix
  ];

  config.home-manager.sharedModules = [
    ({ config, lib, ... }: {
      options.software.virtualization.containers.navidrome = {
        enable = lib.mkEnableOption "Enables Navidrome running as a podman container";
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
          description = "Navidrome container version";
          type = lib.types.str;
        };
      };

      config = lib.mkIf config.software.virtualization.containers.navidrome.enable {
        assertions = [
          {
            assertion = config.software.virtualization.containers.enable;
            message = "Podman containers must be enabled to enable the Navidrome container";
          }
        ];

        services.podman.containers.navidrome-music-server = {
          image = "docker.io/navidrome/navidrome:${config.software.virtualization.containers.navidrome.version}";
          autoStart = true;
          autoUpdate = "registry";
          description = "Navidrome Music Server";
          environment = {
            ND_LOGLEVEL = "info";
            ND_MUSICFOLDER = "/music/main";
          };

          extraPodmanArgs = [
            "--name=navidrome-music-server"
            "--user=${toString config.software.virtualization.containers.navidrome.uid}:${toString config.software.virtualization.containers.navidrome.gid}"
            "--userns=keep-id"
          ];

          network = "hosted-applications";
          networkAlias = [
            "navidrome"
            "navidrome-music-server"
          ];

          ports = [
            "4533:4533"
          ];

          volumes = [
            "/srv/configuration/navidrome/data:/data:Z"
            "/srv/media/navidrome:/music:Z,ro"
          ];
        };
      };
    })
  ];
}
