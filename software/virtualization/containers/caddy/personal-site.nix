{ config, lib, pkgs, ... }:

let
  any-user-has-caddy-enabled = builtins.any (user: config.home-manager.users.${user}.software.virtualization.containers.caddy.enable) (builtins.attrNames config.home-manager.users);
in
{
  options.custom-packages.personal-site = lib.mkOption {
    description = "Personal site of Elianora Rose";
    type = lib.types.attrs;
  };

  config.custom-packages.personal-site = lib.mkIf any-user-has-caddy-enabled (pkgs.fetchFromGitHub {
    owner = "elianora";
    repo = "personal-site";
    rev = "bfb58a65b28259b041926d48ce5e113e1b5357d9";
    hash = "sha256-RrUJ5lnbe6whEX+SZ0y/VlOpMVIcymlqISTIxxqVKDc=";
  });
}
