{ config, inputs, lib, pkgs, ... }:

let
  any-user-has-caddy-enabled = builtins.any (user: config.home-manager.users.${user}.software.virtualization.containers.caddy.enable) (builtins.attrNames config.home-manager.users);
  caddyfile-contents = lib.concatStrings [
    ''
      {
        email support@elianorarose.com
        acme_dns porkbun {
          api_key $PORKBUN_API_KEY
          api_secret_key $PORKBUN_SECRET_KEY
        }

        cert_issuer acme {
          disable_http_challenge
          disable_tlsalpn_challenge
        }
      }

      (dns01_challenge) {
        @endpoints {
          path /present /cleanup
        }

        handle @endpoints {
          dns01proxy {
            resolvers 1.1.1.1 1.0.0.1
            user $CADDY_DNS01_USERNAME {
              password $CADDY_DNS01_HASHED_PASSWORD
              allow_domains {args[0]}
            }
          }
        }
      }

      elianorarose.com {
        import dns01_challenge elianorarose.com
        redir {scheme}://www.{host}{uri}
      }

      www.elianorarose.com, :443 {
        import dns01_challenge www.elianorarose.com
        root /srv/elianorarose.com
        file_server

        handle_errors {
          respond "{http.error.status_code} {http.error.status_text}"
        }

        log {
          format json
          output file /logs/elianorarose.com.log.json
          level ERROR
        }
      }
    ''
    (lib.optionalString config.home-manager.users.${podman-user}.software.virtualization.containers.jellyfin.enable ''

      media.elianorarose.com {
        import dns01_challenge media.elianorarose.com
        reverse_proxy jellyfin:8096
      }
    '')
    (lib.optionalString config.home-manager.users.${podman-user}.software.virtualization.containers.jellyfin.enable ''

      music.elianorarose.com {
        import dns01_challenge music.elianorarose.com
        reverse_proxy navidrome:4533
      }
    '')
  ];

  sops-secret-file-config = {
    group = "service-users";
    mode = "0440";
    owner = podman-user;
  };

  podman-user = lib.findSingle
    (user: config.home-manager.users.${user}.software.virtualization.containers.enable)
    (throw "No podman users were found for rootless podman to run as")
    (throw "Multiple podman users were found, enable at most one")
    (builtins.attrNames config.home-manager.users);
in
{
  config = lib.mkIf any-user-has-caddy-enabled {
    sops.secrets = {
      "porkbun/api-key" = sops-secret-file-config;
      "porkbun/password" = sops-secret-file-config;
      "porkbun/secret-key" = sops-secret-file-config;
      "porkbun/username" = sops-secret-file-config;
    };

    system.activationScripts.create-and-copy-caddy-files.text = ''
      create_podman_directory () {
        mkdir -p $3
        chown "''${1}:''${2}" $3
        chmod 0775 $3
        find "''${3}/" -type d -exec chown "''${1}:''${2}" {} +
        find "''${3}/" -type d -exec chmod 0775 {} +
        find "''${3}/" -type f -exec chown "''${1}:''${2}" {} +
        find "''${3}/" -type f -exec chmod 0664 {} +
      }

      create_podman_directory ${podman-user} service-users /srv/configuration
      create_podman_directory ${podman-user} service-users /srv/configuration/caddy
      create_podman_directory ${podman-user} service-users /srv/configuration/caddy/config
      create_podman_directory ${podman-user} service-users /srv/configuration/caddy/data
      create_podman_directory ${podman-user} service-users /srv/configuration/caddy/etc
      create_podman_directory ${podman-user} service-users /srv/configuration/caddy/logs
      create_podman_directory ${podman-user} service-users /srv/www
      create_podman_directory ${podman-user} service-users /srv/www/elianorarose.com

      # Clean old site contents to ensure as close to declarative as possible
      rm -rf /srv/www/elianorarose.com/*
      cp -R ${inputs.personal-site.packages.${pkgs.stdenv.hostPlatform.system}.personal-site}/* /srv/www/elianorarose.com/

      # Set namesilo API key
      PORKBUN_API_KEY=$(cat ${config.sops.secrets."porkbun/api-key".path})
      PORKBUN_SECRET_KEY=$(cat ${config.sops.secrets."porkbun/secret-key".path})

      # Set user/pass
      CADDY_DNS01_USERNAME=$(cat ${config.sops.secrets."porkbun/username".path})
      CADDY_DNS01_HASHED_PASSWORD=$(cat ${config.sops.secrets."porkbun/password".path})

      # Add Caddyfile to the container
      mkdir -p /srv/configuration/caddy/etc
      rm -f /srv/configuration/caddy/etc/Caddyfile
      cat <<- CADDYFILE_EOF > /srv/configuration/caddy/etc/Caddyfile
      ${caddyfile-contents}
      CADDYFILE_EOF

      chown root:service-users /srv/configuration/caddy/etc/Caddyfile
      chmod 0664 /srv/configuration/caddy/etc/Caddyfile
    '';

    systemd.tmpfiles.rules = [
      # SEE:
      # Permissions calc: https://linuxize.com/tools/chmod-calculator/
      # Tmpfiles format: https://www.man7.org/linux/man-pages/man5/tmpfiles.d.5.html
      ''v "/srv/configuration/caddy" 0775 ${podman-user} service-users''
      ''v "/srv/configuration/caddy/config" 0775 ${podman-user} service-users''
      ''v "/srv/configuration/caddy/data" 0775 ${podman-user} service-users''
      ''v "/srv/configuration/caddy/etc" 0775 ${podman-user} service-users''
      ''v "/srv/configuration/caddy/logs" 0775 ${podman-user} service-users''
      ''v "/srv/www/elianorarose.com" 0775 ${podman-user} service-users''
      ''z "/srv/configuration/caddy" 0775 ${podman-user} service-users''
      ''z "/srv/configuration/caddy/config" 0775 ${podman-user} service-users''
      ''z "/srv/configuration/caddy/data" 0775 ${podman-user} service-users''
      ''z "/srv/configuration/caddy/etc" 0775 ${podman-user} service-users''
      ''z "/srv/configuration/caddy/logs" 0775 ${podman-user} service-users''
      ''z "/srv/configuration" 0775 ${podman-user} service-users''
      ''z "/srv/www" 0775 ${podman-user} service-users''
      ''z "/srv/www/elianorarose.com" 0775 ${podman-user} service-users''
    ];
  };
}
