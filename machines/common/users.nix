{ config, lib, pkgs, ... }:

let
  user-groups = builtins.filter (user: !config.home-manager.users.${user}.service-user) users;
  users = builtins.attrNames config.home-manager.users;
in
{
  config = {
    nix.settings.allowed-users = [ "@wheel" ] ++ users;
    users = {
      groups = builtins.listToAttrs (map (group: {
        name = group;
        value.name = group;
      }) ([ "service-users" ] ++ user-groups));

      users = builtins.listToAttrs (map (user: {
        name = user;
        value = {
          description = config.home-manager.users.${user}.display-name;
          extraGroups =
            (lib.optional config.home-manager.users.${user}.service-user "service-users")
            ++ (lib.optional config.home-manager.users.${user}.sudoer "wheel")
            ++ (lib.optionals (!config.home-manager.users.${user}.service-user) [
              "audio"
              "libvirtd"
              "networkmanager"
            ]);

          isNormalUser = true;
          linger = config.home-manager.users.${user}.service-user;
          openssh.authorizedKeys.keys = config.home-manager.users.${user}.ssh-authorized-keys;
          shell = pkgs.bash;
        };
      }) users);
    };
  };
}
