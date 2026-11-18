{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.multimedia.kdenlive.enable = lib.mkEnableOption "Enable Kdenlive video editor";
      config = lib.mkIf config.software.multimedia.kdenlive.enable {
        assertions = [
          {
            assertion = config.software.desktop-environments.plasma.enable;
            message = "A desktop environment is required to enable Kdenlive";
          }
        ];

        home.packages = with pkgs; [
          kdePackages.kdenlive
        ];
      };
    })
  ];
}
