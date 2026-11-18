{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, ... }: {
      options.software.core.jq.enable = lib.mkEnableOption "Enable jq";
      config.programs.jq.enable = config.software.core.jq.enable;
    })
  ];
}
