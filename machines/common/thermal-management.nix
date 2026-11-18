{ config, lib, ... }:

{
  options.thermal-management.enable = lib.mkOption {
    default = config.system-type == "laptop";
    description = "Enable thermal management (used to stop laptops from overheating)";
    type = lib.types.bool;
  };

  config.services.thermald.enable = config.thermal-management.enable;
}
