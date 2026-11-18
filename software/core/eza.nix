{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, ... }: {
      options.software.core.eza.enable = lib.mkEnableOption "Enable eza (ls replacement)";
      config.programs.eza = lib.mkIf config.software.core.eza.enable {
        enable = true;
        enableBashIntegration = true;
        colors = "auto";
        extraOptions = [
          "-l"
          "-a"
          "-h"
          "-g"
          "--group-directories-first"
        ];

        git = config.software.core.git.enable;
      };
    })
  ];
}
