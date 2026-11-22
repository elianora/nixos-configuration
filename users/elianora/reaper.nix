{ inputs, pkgs, ... }:

{
  config.programs.reaper = {
    preferences.general.startupSettings.showSplashScreenOnStartup = false;
    swell.colortheme = {
      enable = true;
      preset = inputs.reaper-flake.packages.${pkgs.stdenv.hostPlatform.system}.realinux-dark-swell-theme;
    };

    theme = {
      active = "Reapertips Theme.ReaperThemeZip";
      colorThemes = [];
      packages = [
        inputs.reaper-flake.packages.${pkgs.stdenv.hostPlatform.system}.reapertips-theme
      ];
    };
  };
}
