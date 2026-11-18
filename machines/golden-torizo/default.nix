{ ... }:

{
  # NOTE:
  # The actual hardware in this machine is as follows:
  # - Dell XPS 17 9700 with 4K Screen Option
  # - Intel Core i7-10875H
  # - NVIDIA GeForce RTX 2060 6GB
  # - 32GB of DDR4-2933 RAM

  imports = [
    ../common
    ./bluetooth.nix
    ./boot.nix
    ./filesystems.nix
    ./graphics.nix
    ./networking.nix
    ./platform.nix
  ];

  config = {
    audio.pulse-audio.enable = true;
    localization = {
      locale = "en_US.UTF-8";
      timeZone = "America/New_York";
    };

    software = {
      virtualization.cpu-type = "intel";
    };

    printing.enable = true;
    system-type = "laptop";
  };
}
