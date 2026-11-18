{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, ... }: {
      options.software.office-and-notes.obsidian.enable = lib.mkEnableOption "Enable Obsidian markdown editor";
      config = lib.mkIf config.software.office-and-notes.obsidian.enable {
        assertions = [
          {
            assertion = config.software.desktop-environments.plasma.enable;
            message = "A desktop environment is required to enable LibreOffice";
          }
        ];

        services.flatpak = {
          enable = true;
          packages = [ "flathub:app/md.obsidian.Obsidian//stable" ];
          remotes.flathub = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        };
      };
    })
  ];
}
