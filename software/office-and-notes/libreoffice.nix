{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.office-and-notes.libreoffice.enable = lib.mkEnableOption "Enable LibreOffice";
      config = lib.mkIf config.software.office-and-notes.libreoffice.enable {
        assertions = [
          {
            assertion = config.software.desktop-environments.plasma.enable;
            message = "A desktop environment is required to enable LibreOffice";
          }
        ];

        home.packages = with pkgs; [
          libreoffice-qt-fresh
        ];
      };
    })
  ];
}
