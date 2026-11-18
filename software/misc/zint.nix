{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.misc.zint.enable = lib.mkEnableOption "Enable Zint barcode generator";
      config = lib.mkIf config.software.misc.zint.enable {
        assertions = [
          {
            assertion = config.software.desktop-environments.plasma.enable;
            message = "A desktop environment is required to enable Zint";
          }
        ];

        home.packages = with pkgs; [
          zint-qt
        ];
      };
    })
  ];
}
