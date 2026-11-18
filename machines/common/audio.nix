{ config, lib, ... }:

{
  options.audio = {
    has-recording-device = lib.mkEnableOption "Whether this machine has a recording device installed";
    pulse-audio.enable = lib.mkEnableOption "Enable pulse-audio";
  };

  config = lib.mkIf config.audio.pulse-audio.enable {
    nixpkgs.config.pulseaudio = true;
    security.rtkit.enable = true;
    services = {
      pulseaudio.enable = false;
      pipewire = {
        alsa = {
          enable = true;
          support32Bit = true;
        };

        enable = true;
        pulse.enable = true;
      };
    };
  };
}
