{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.browsers.firefox.enable = lib.mkEnableOption "Enable Firefox web browser";
      config = lib.mkIf config.software.browsers.firefox.enable {
        assertions = [
          {
            assertion = config.software.desktop-environments.plasma.enable;
            message = "A desktop environment is required to enable Firefox";
          }
        ];

        programs.firefox = {
          enable = true;
          package = pkgs.firefox-bin;
        };
      };
    })
  ];
}
