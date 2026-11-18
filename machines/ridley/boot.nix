{ config, pkgs, ... }:

{
  config.boot = {
    consoleLogLevel = 3;
    extraModulePackages = [
      config.hardware.nvidia.package
    ];

    initrd = {
      availableKernelModules = [
        "ahci"
        "nvme"
        "sd_mod"
        "usb_storage"
        "usbhid"
        "xhci_pci"
      ];

      verbose = false;
    };

    kernelModules = [
      "kvm-amd"
      "nvidia_drm"
      "nvidia"
    ];

    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "quiet"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=auto"
    ];

    loader = {
      efi.canTouchEfiVariables = true;
      limine = {
        enable = true;
        maxGenerations = 20;
        resolution = "3440x1440";
        secureBoot.enable = true;
        style.interface.resolution = "3440x1440";
      };

      timeout = 3;
    };

    plymouth.enable = true;
  };
}
