{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.multimedia.vlc.enable = lib.mkEnableOption "Enable VLC media player";
      config = lib.mkIf config.software.multimedia.vlc.enable {
        assertions = [
          {
            assertion = config.software.desktop-environments.plasma.enable;
            message = "A desktop environment is required to enable VLC";
          }
        ];

        home.packages = with pkgs; [
          vlc
        ];
      };
    })
  ];
}
