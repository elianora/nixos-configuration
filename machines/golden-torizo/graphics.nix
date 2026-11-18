{ lib, ... }:

{
  config = {
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };

      nvidia = {
        driver.enable = true;
        prime = {
          intelBusId = lib.mkDefault "PCI:0:2:0";
          nvidiaBusId = lib.mkDefault "PCI:1:0:0";
        };
      };
    };

    services.xserver.videoDrivers = [
      "intel"
      "nvidia"
    ];
  };
}
