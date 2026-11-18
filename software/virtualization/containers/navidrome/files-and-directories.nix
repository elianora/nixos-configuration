{ config, lib, ... }:

let
  any-user-has-navidrome-enabled = builtins.any (user: config.home-manager.users.${user}.software.virtualization.containers.navidrome.enable) (builtins.attrNames config.home-manager.users);
  podman-user = lib.findSingle
    (user: config.home-manager.users.${user}.software.virtualization.containers.enable)
    (throw "No podman users were found for rootless podman to run as")
    (throw "Multiple podman users were found, enable at most one")
    (builtins.attrNames config.home-manager.users);
in
{
  config = lib.mkIf any-user-has-navidrome-enabled {
    system.activationScripts.create-and-copy-navidrome-files.text = ''
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
      create_podman_directory ${podman-user} service-users /srv/configuration/navidrome
      create_podman_directory ${podman-user} service-users /srv/configuration/navidrome/data
      create_podman_directory ${podman-user} service-users /srv/media
      create_podman_directory ${podman-user} service-users /srv/media/navidrome
      create_podman_directory ${podman-user} service-users /srv/media/navidrome/game-soundtracks
      create_podman_directory ${podman-user} service-users /srv/media/navidrome/main
      create_podman_directory ${podman-user} service-users /srv/media/navidrome/musicals
    '';

    systemd.tmpfiles.rules = [
      # SEE:
      # Permissions calc: https://linuxize.com/tools/chmod-calculator/
      # Tmpfiles format: https://www.man7.org/linux/man-pages/man5/tmpfiles.d.5.html
      ''v "/srv/configuration/navidrome" 0775 ${podman-user} service-users''
      ''v "/srv/configuration/navidrome/data" 0775 ${podman-user} service-users''
      ''v "/srv/media/navidrome" 0775 ${podman-user} service-users''
      ''v "/srv/media/navidrome/game-soundtracks" 0775 ${podman-user} service-users''
      ''v "/srv/media/navidrome/main" 0775 ${podman-user} service-users''
      ''v "/srv/media/navidrome/musicals" 0775 ${podman-user} service-users''
      ''z "/srv/configuration" 0775 ${podman-user} service-users''
      ''z "/srv/configuration/navidrome" 0775 ${podman-user} service-users''
      ''z "/srv/configuration/navidrome/data" 0775 ${podman-user} service-users''
      ''z "/srv/media" 0775 ${podman-user} service-users''
      ''z "/srv/media/navidrome" 0775 ${podman-user} service-users''
      ''z "/srv/media/navidrome/game-soundtracks" 0775 ${podman-user} service-users''
      ''z "/srv/media/navidrome/main" 0775 ${podman-user} service-users''
      ''z "/srv/media/navidrome/musicals" 0775 ${podman-user} service-users''
    ];
  };
}
