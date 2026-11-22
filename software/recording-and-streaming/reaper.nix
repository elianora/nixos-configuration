{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, osConfig, pkgs, ... }: {
      options.software.recording-and-streaming.reaper.enable = lib.mkEnableOption "Enable Reaper";
      config = lib.mkIf config.software.recording-and-streaming.reaper.enable {
        assertions = [
          {
            assertion = config.software.desktop-environments.plasma.enable;
            message = "A desktop environment is required to enable Reaper";
          }
          {
            assertion = osConfig.audio.has-recording-device;
            message = "Reaper requires this machine (${osConfig.networking.hostName}) to have a recording device";
          }
        ];

        programs.reaper = {
          enable = true;
          experimental.swell-wayland.enable = true;
          packages = with pkgs; [
            cairo
            fontconfig
            freetype
            glib
            gtk3
            libepoxy
            libpng
            zlib
          ];
        };
      };
    })
  ];
}
