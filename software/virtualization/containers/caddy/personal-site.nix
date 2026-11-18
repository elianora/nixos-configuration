{ config, lib, ... }:

let
  any-user-has-caddy-enabled = builtins.any (user: config.home-manager.users.${user}.software.virtualization.containers.caddy.enable) (builtins.attrNames config.home-manager.users);
in
{
  options.custom-packages.personal-site = lib.mkOption {
    description = "Personal site of Elianora Rose";
    type = lib.types.attrs;
  };

  config.custom-packages.personal-site = lib.mkIf any-user-has-caddy-enabled (fetchGit {
    name = "personal-site";
    ref = "main";
    rev = "0a7efca107ba4d49b607884e22e37b3c006f79fe";
    url = "git+https://codeberg.org/elianora/personal-site.git";
  });
}
