{ config, lib, ... }:

{
  config.programs.plasma.fonts = lib.mkIf config.software.desktop-environments.plasma.enable {
    fixedWidth = {
      family = "Fira Code";
      pointSize = 11;
      style = "normal";
    };

    general = {
      family = "DejaVu Sans";
      pointSize = 11;
      style = "normal";
    };

    menu = {
      family = "DejaVu Sans";
      pointSize = 11;
      style = "normal";
    };

    small = {
      family = "DejaVu Sans";
      pointSize = 9;
      style = "normal";
    };

    toolbar = {
      family = "DejaVu Sans";
      pointSize = 11;
      style = "normal";
    };

    windowTitle = {
      family = "DejaVu Sans";
      pointSize = 11;
      style = "normal";
    };
  };
}
