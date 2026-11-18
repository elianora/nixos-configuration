{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, ... }: {
      options.software.core.fastfetch.enable = lib.mkEnableOption "Enable fastfetch";
      config.programs.fastfetch.enable = config.software.core.fastfetch.enable;
    })
  ];
}
