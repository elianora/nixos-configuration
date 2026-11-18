{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.multimedia.beets.enable = lib.mkEnableOption "Enable beets.io music organizer";
      config = lib.mkIf config.software.multimedia.beets.enable {
        home.packages = with pkgs; [
          beets
        ];
      };
    })
  ];
}
