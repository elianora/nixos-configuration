{ ... }:

{
  config = {
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };

      nvidia.driver.enable = true;
    };

    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
