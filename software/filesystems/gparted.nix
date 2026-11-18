{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.filesystems.gparted.enable = lib.mkEnableOption "Enable gparted";
      config = lib.mkIf config.software.filesystems.gparted.enable {
        assertions = [
          {
            assertion = config.software.desktop-environments.plasma.enable;
            message = "A desktop environment is required to enable gparted";
          }
        ];

        home.packages = lib.optional config.software.filesystems.gparted.enable pkgs.gparted-full;
      };
    })
  ];
}
