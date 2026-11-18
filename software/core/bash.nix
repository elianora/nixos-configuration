{ ... }:

{
  config = {
    home-manager.sharedModules = [
      ({ config, lib, ... }: {
        config.programs.bash = {
          enable = true;
          shellAliases.ls = lib.mkIf config.software.core.eza.enable "eza ";
        };
      })
    ];

    programs.bash = {
      enable = true;
      completion.enable = true;
    };
  };
}
