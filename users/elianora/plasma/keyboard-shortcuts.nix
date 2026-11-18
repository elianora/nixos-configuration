{ config, lib, ... }:

{
  config.programs.plasma.shortcuts = lib.mkIf config.software.desktop-environments.plasma.enable {
    kwin."Window Maximize" = "Meta+Up";
    kwin."Window Maximize Vertical" = "Meta+Down";
  };
}
