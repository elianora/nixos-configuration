{ config, lib, ... }:

{
  options = {
    headless = lib.mkOption {
      default = config.system-type == "server";
      description = "Whether to disable GUI options by default";
      type = lib.types.bool;
    };

    system-type = lib.mkOption {
      description = "The type of system this is (desktop, laptop, server)";
      type = lib.types.enum [
        "desktop"
        "laptop"
        "server"
      ];
    };
  };
}
