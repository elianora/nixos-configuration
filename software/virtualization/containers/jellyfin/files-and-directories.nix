{ config, lib, ... }:

let
  any-user-has-jellyfin-enabled = builtins.any (user: config.home-manager.users.${user}.software.virtualization.containers.jellyfin.enable) (builtins.attrNames config.home-manager.users);
  podman-user = lib.findSingle
    (user: config.home-manager.users.${user}.software.virtualization.containers.enable)
    (throw "No podman users were found for rootless podman to run as")
    (throw "Multiple podman users were found, enable at most one")
    (builtins.attrNames config.home-manager.users);
in
{
  config = lib.mkIf any-user-has-jellyfin-enabled {
    system.activationScripts.create-and-copy-jellyfin-files.text = ''
      create_podman_directory () {
        mkdir -p $3
        chown "''${1}:''${2}" $3
        chmod 0775 $3
        find "''${3}/" -type d -exec chmod 0775 {} +
        find "''${3}/" -type f -exec chown ${podman-user}:service-users 0664 {} +
        find "''${3}/" -type f -exec chmod 0664 {} +
      }

      create_podman_directory root service-users /srv/configuration
      create_podman_directory ${podman-user} service-users /srv/configuration/jellyfin
      create_podman_directory ${podman-user} service-users /srv/configuration/jellyfin/cache
      create_podman_directory ${podman-user} service-users /srv/configuration/jellyfin/config
      create_podman_directory root service-users /srv/media
      create_podman_directory ${podman-user} service-users /srv/media/jellyfin
      create_podman_directory ${podman-user} service-users /srv/media/jellyfin/anime
      create_podman_directory ${podman-user} service-users /srv/media/jellyfin/audiobooks
      create_podman_directory ${podman-user} service-users /srv/media/jellyfin/books
      create_podman_directory ${podman-user} service-users /srv/media/jellyfin/movies
      create_podman_directory ${podman-user} service-users /srv/media/jellyfin/music
      create_podman_directory ${podman-user} service-users /srv/media/jellyfin/pictures
      create_podman_directory ${podman-user} service-users /srv/media/jellyfin/tv
    '';

    systemd.tmpfiles.rules = [
      # SEE:
      # Permissions calc: https://linuxize.com/tools/chmod-calculator/
      # Tmpfiles format: https://www.man7.org/linux/man-pages/man5/tmpfiles.d.5.html
      ''v "/srv/configuration/jellyfin" 0775 ${podman-user} service-users''
      ''v "/srv/configuration/jellyfin/cache" 0775 ${podman-user} service-users''
      ''v "/srv/configuration/jellyfin/config" 0775 ${podman-user} service-users''
      ''v "/srv/media/jellyfin" 0775 ${podman-user} service-users''
      ''v "/srv/media/jellyfin/anime" 0775 ${podman-user} service-users''
      ''v "/srv/media/jellyfin/audiobooks" 0775 ${podman-user} service-users''
      ''v "/srv/media/jellyfin/books" 0775 ${podman-user} service-users''
      ''v "/srv/media/jellyfin/movies" 0775 ${podman-user} service-users''
      ''v "/srv/media/jellyfin/music" 0775 ${podman-user} service-users''
      ''v "/srv/media/jellyfin/pictures" 0775 ${podman-user} service-users''
      ''v "/srv/media/jellyfin/tv" 0775 ${podman-user} service-users''
      ''z "/srv/configuration" 0775 root service-users''
      ''z "/srv/configuration/jellyfin" 0775 ${podman-user} service-users''
      ''z "/srv/configuration/jellyfin/cache" 0775 ${podman-user} service-users''
      ''z "/srv/configuration/jellyfin/config" 0775 ${podman-user} service-users''
      ''z "/srv/media" 0775 root service-users''
      ''z "/srv/media/jellyfin" 0775 ${podman-user} service-users''
      ''z "/srv/media/jellyfin/anime" 0775 ${podman-user} service-users''
      ''z "/srv/media/jellyfin/audiobooks" 0775 ${podman-user} service-users''
      ''z "/srv/media/jellyfin/books" 0775 ${podman-user} service-users''
      ''z "/srv/media/jellyfin/movies" 0775 ${podman-user} service-users''
      ''z "/srv/media/jellyfin/music" 0775 ${podman-user} service-users''
      ''z "/srv/media/jellyfin/pictures" 0775 ${podman-user} service-users''
      ''z "/srv/media/jellyfin/tv" 0775 ${podman-user} service-users''
    ];
  };
}
