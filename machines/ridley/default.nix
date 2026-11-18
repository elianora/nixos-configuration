{ lib, ... }:

{
  # NOTE:
  # The actual hardware in or connected to this machine is as follows:
  # - MSI MAG X670E TOMAHAWK WIFI Motherboard
  # - Ryzen 9 7950X3D
  # - 64GB of DDR5-6000 CL30 RAM
  # - Gigabyte OC GeForce RTX 4090 24GB
  # - Crucial T705 2TB PCIe NVME drive
  # - Dell AW3418DW 34.1" 120hz Curved Monitor
  # - Acer XB270HU bprz 27" 144hz Monitor
  # - Logitech BRIO 4k Webcam
  # - Scarlett 2i4 4th Generation Audio Interface
  # - Stream Deck MK.2
  # - AVerMedia Live Gamer 4K 2.1 Capture Card (GC575)

  imports = [
    ../common
    ./audio.nix
    ./bluetooth.nix
    ./boot.nix
    ./filesystems.nix
    ./graphics.nix
    ./networking.nix
    ./platform.nix
  ];

  config = {
    audio = {
      has-recording-device = true;
      pulse-audio.enable = true;
    };

    localization = {
      locale = "en_US.UTF-8";
      timeZone = "America/New_York";
    };

    printing.enable = true;
    recording = {
      has-capture-card = true;
      has-stream-deck = true;
    };

    software = {
      networking.ssh.enable = true;
      virtualization = {
        cpu-type = "amd";
        kvm = {
          enable = true;
          vfio-passthrough = {
            enable = true;
            cpu-threads = {
              all = lib.range 0 31;
              emulator = [ 8 24 ];
              host = (lib.range 8 15) ++ (lib.range 24 31);
              io = [ 8 24 ];
              vm = [
                { vcpu = 00; cpuset = 00; }
                { vcpu = 01; cpuset = 16; }
                { vcpu = 02; cpuset = 01; }
                { vcpu = 03; cpuset = 17; }
                { vcpu = 04; cpuset = 02; }
                { vcpu = 05; cpuset = 18; }
                { vcpu = 06; cpuset = 03; }
                { vcpu = 07; cpuset = 19; }
                { vcpu = 08; cpuset = 04; }
                { vcpu = 09; cpuset = 20; }
                { vcpu = 10; cpuset = 05; }
                { vcpu = 11; cpuset = 21; }
                { vcpu = 12; cpuset = 06; }
                { vcpu = 13; cpuset = 22; }
                { vcpu = 14; cpuset = 07; }
                { vcpu = 15; cpuset = 23; }
              ];
            };

            pci-identifiers = {
              gpu = "pci_0000_01_00_0";
              gpu-audio = "pci_0000_01_00_1";
              hd-audio = "pci_0000_17_00_6";
            };

            vm-memory = 32768;
          };

          virtual-machines.win11.enable = true;
        };
      };
    };

    system-type = "desktop";
  };
}
