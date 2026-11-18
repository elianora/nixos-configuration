{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.core.system-monitoring-utils.enable = lib.mkEnableOption "Enable system monitoring utilities";
      config.home.packages = lib.optionals config.software.core.system-monitoring-utils.enable (with pkgs; [
        btop
        iotop
        lm_sensors
        nvtopPackages.full
        pciutils
        sysstat
      ]);
    })
  ];
}
