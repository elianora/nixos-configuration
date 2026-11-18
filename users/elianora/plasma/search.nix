{ config, lib, ... }:

{
  config.programs.plasma.searchPlugins = lib.mkIf config.software.desktop-environments.plasma.enable {
    webSearchKeywords.enable = false;
  };
}
