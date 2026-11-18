{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, ... }: {
      options.software.browsers.vivaldi.enable = lib.mkEnableOption "Enable Vivaldi web browser";
      config = lib.mkIf config.software.browsers.vivaldi.enable {
        assertions = [
          {
            assertion = config.software.desktop-environments.plasma.enable;
            message = "A desktop environment is required to enable Vivaldi";
          }
        ];

        programs.vivaldi.enable = true;
      };
    })
  ];
}
