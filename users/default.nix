{ config, inputs, lib, ... }:

let
  user-configs = map (username: {
    name = username;
    value = ({ inputs, ... }: {
      imports = [
        inputs.flatpaks.homeModules.default
        ./${username}
      ];

      options = {
        display-name = lib.mkOption {
          description = "The display name of the user";
          type = lib.types.str;
        };

        service-user = lib.mkEnableOption "Whether the user is a service user";
        sudoer = lib.mkOption {
          default = true;
          description = "Whether to add the user to the sudoers group";
          type = lib.types.bool;
        };
      };

      # This value determines the home Manager release that your
      # configuration is compatible with. This helps avoid breakage
      # when a new home Manager release introduces backwards
      # incompatible changes.
      #
      # You can update home Manager without changing this value. See
      # the home Manager release notes for a list of state version
      # changes in each release.
      config.home.stateVersion = "26.05";
    });
  }) users;

  users = [
    "elianora"
  ] ++ (lib.optional (config.system-type == "server") "podman");
in
{
  config.home-manager = {
    backupFileExtension = "hm-backup-${toString inputs.self.lastModifiedDate}";
    extraSpecialArgs = { inherit inputs; };
    sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
    useGlobalPkgs = true;
    useUserPackages = true;
    users = builtins.listToAttrs user-configs;
  };
}
