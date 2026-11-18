{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, osConfig, pkgs, ... }: {
      options.software.recording-and-streaming.tenacity.enable = lib.mkEnableOption "Enable Tenacity";
      config = lib.mkIf config.software.recording-and-streaming.tenacity.enable {
        assertions = [
          {
            assertion = config.software.desktop-environments.plasma.enable;
            message = "A desktop environment is required to enable Tenacity";
          }
          {
            assertion = osConfig.audio.has-recording-device;
            message = "Tenacity requires this machine (${osConfig.networking.hostName}) to have a recording device";
          }
        ];

        home.packages = with pkgs; [
          tenacity
        ];
      };
    })
  ];
}
