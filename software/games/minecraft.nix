{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.games.minecraft.enable = lib.mkEnableOption "Enable Minecraft via Prism launcher";
      config = lib.mkIf config.software.games.minecraft.enable {
        assertions = [
          {
            assertion = config.software.desktop-environments.plasma.enable;
            message = "A desktop environment is required to enable Minecraft via Prism launcher";
          }
        ];

        programs.prismlauncher = {
          enable = true;
          config.java.path = "${pkgs.jdk25}/bin/java";
        };
      };
    })
  ];
}
