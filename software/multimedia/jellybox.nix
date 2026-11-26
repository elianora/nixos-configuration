{ ... }:

{
  config = {
    home-manager.sharedModules = [
      ({ config, lib, ... }: {
        options.software.multimedia.jellybox.enable = lib.mkEnableOption "Enable Jellybox";
        config = lib.mkIf config.software.multimedia.jellybox.enable {
          assertions = [
            {
              assertion = config.software.desktop-environments.plasma.enable;
              message = "A desktop environment is required to enable Jellybox";
            }
          ];

          services.flatpak = {
            enable = true;
            packages = [ "jellybox:app/com.prodigytech.jellybox//master" ];
            remotes.jellybox = "https://flatpak.jellybox.app/jellybox.flatpakrepo";
          };
        };
      })
    ];
  };
}
