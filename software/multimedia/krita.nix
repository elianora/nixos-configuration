{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.multimedia.krita.enable = lib.mkEnableOption "Enable Krita";
      config = lib.mkIf config.software.multimedia.krita.enable {
        assertions = [
          {
            assertion = config.software.desktop-environments.plasma.enable;
            message = "A desktop environment is required to enable Krita";
          }
        ];

        home.packages = with pkgs; [
          krita
        ];
      };
    })
  ];
}
