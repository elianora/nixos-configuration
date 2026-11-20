{ ... }:

{
  imports = [
    ./files-and-directories.nix
    ./image-dockerfile.nix
    ./networking.nix
  ];

  config.home-manager.sharedModules = [
    ({ config, lib, ... }: {
      options.software.virtualization.containers.caddy = {
        enable = lib.mkEnableOption "Enables Caddy running as a podman container";
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
          default = "2.11";
          description = "Caddy container version";
          type = lib.types.str;
        };
      };

      config = lib.mkIf config.software.virtualization.containers.caddy.enable {
        assertions = [
          {
            assertion = config.software.virtualization.containers.enable;
            message = "Podman containers must be enabled to enable the Caddy container";
          }
        ];

        services.podman = {
          builds.caddy = {
            description = "Caddy reverse proxy with custom modules";
            file = config.software.virtualization.containers.caddy.dockerfile;
          };

          containers.caddy-reverse-proxy = {
            image = "localhost/homemanager/caddy";
            addCapabilities = [
              "NET_ADMIN"
            ];

            autoStart = true;
            autoUpdate = "registry";
            description = "Caddy Reverse Proxy";
            extraConfig = {
              Unit = {
                After = builtins.concatStringsSep ", " [
                  "podman-caddy-build.service"
                ];
              };
            };

            extraPodmanArgs = [
              "--name=caddy-reverse-proxy"
              "--user=${toString config.software.virtualization.containers.caddy.uid}:${toString config.software.virtualization.containers.caddy.gid}"
              "--userns=keep-id"
            ];

            network = "hosted-applications";
            networkAlias = [
              "caddy"
              "caddy-reverse-proxy"
            ];

            ports = [
              "80:80"
              "443:443"
              "443:443/udp"
              "2019:2019"
            ];

            volumes = [
              "/srv/configuration/caddy/config:/config:Z"
              "/srv/configuration/caddy/data:/data:Z"
              "/srv/configuration/caddy/etc:/etc/caddy:Z"
              "/srv/configuration/caddy/logs:/logs:Z"
              "/srv/www/elianorarose.com:/srv/elianorarose.com:z"
            ];
          };
        };
      };
    })
  ];
}
