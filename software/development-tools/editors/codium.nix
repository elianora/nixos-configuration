{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, ... }: {
      options.software.development-tools.editors.codium.enable = lib.mkEnableOption "Enable VSCodium editor";
      config = lib.mkIf config.software.development-tools.editors.codium.enable {
        assertions = [
          {
            assertion = config.software.desktop-environments.plasma.enable;
            message = "A desktop environment is required to enable VSCodium";
          }
        ];

        programs.vscodium.enable = true;
      };
    })
  ];
}
