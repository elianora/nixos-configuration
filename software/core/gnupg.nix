{ config, lib, ... }:

{
  config = {
    home-manager.sharedModules = [
      ({ config, lib, ... }: {
        options.software.core.gnupg.enable = lib.mkEnableOption "Enable GNU privacy guard";
        config.programs.gpg.enable = config.software.core.gnupg.enable;
      })
    ];

    programs.gnupg.agent = lib.mkIf (builtins.any (user: config.home-manager.users.${user}.software.core.gnupg.enable) (builtins.attrNames config.home-manager.users)) {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
