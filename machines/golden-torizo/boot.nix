{ config, pkgs, ... }:

{
  config.boot = {
    consoleLogLevel = 3;
    extraModulePackages = [
      config.hardware.nvidia.package
    ];

    initrd = {
      availableKernelModules = [
        "nvme"
        "rtsx_pci_sdmmc"
        "sd_mod"
        "usb_storage"
        "xhci_pci"
      ];

      verbose = false;
    };

    kernelModules = [
      "kvm-intel"
      "nvidia_drm"
      "nvidia"
    ];

    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "acpi_rev_override"
      "quiet"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=auto"
    ];

    kernelPatches = [
      {
        name = "enable-soundwire-drivers";
        patch = null;
        extraConfig = ''
          SND_SOC_INTEL_USER_FRIENDLY_LONG_NAMES y
          SND_SOC_INTEL_SOUNDWIRE_SOF_MACH m
          SND_SOC_RT1308 m
        '';
      }
    ];

    loader = {
      efi.canTouchEfiVariables = true;
      limine = {
        enable = true;
        maxGenerations = 20;
        resolution = "3840x2400";
        secureBoot.enable = true;
        style.interface.resolution = "3840x2400";
      };

      timeout = 3;
    };

    plymouth.enable = true;
  };
}
