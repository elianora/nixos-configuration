{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, osConfig, ... }: {
      options.software.recording-and-streaming.obs-studio.enable = lib.mkEnableOption "Enable OBS Studio";
      config = lib.mkIf config.software.recording-and-streaming.obs-studio.enable {
        assertions = [
          {
            assertion = config.software.desktop-environments.plasma.enable;
            message = "A desktop environment is required to enable OBS Studio";
          }
        ];

        warnings = lib.optional (!osConfig.recording.has-capture-card) "This machine (${osConfig.networking.hostName}) has no capture card to record with";
        programs.obs-studio.enable = true;
      };
    })
  ];
}
