{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, ... }: {
      options.software.development-tools.editors.helix.enable = lib.mkEnableOption "Enable vim editor";
      config.programs.helix = lib.mkIf config.software.development-tools.editors.helix.enable {
        enable = true;
        defaultEditor = true;
        settings.theme = "dracula";
      };
    })
  ];
}
