{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.development-tools.editors.rider.enable = lib.mkEnableOption "Enable Rider integrated development environment";
      config = lib.mkIf config.software.development-tools.editors.rider.enable {
        assertions = [
          {
            assertion = config.software.desktop-environments.plasma.enable;
            message = "A desktop environment is required to enable Rider";
          }
          {
            assertion = config.software.development-tools.languages.dotnet.enable;
            message = ".NET language support is required to enable Rider";
          }
          {
            assertion = false;
            message = "Rider is disallowed temporarily due to being effected by CVE-2026-111497";
          }
        ];

        home.packages = with pkgs; [ jetbrains.rider ];
      };
    })
  ];
}
