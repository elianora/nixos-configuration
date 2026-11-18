{ pkgs, ... }:

{
  config.boot = {
    consoleLogLevel = 3;

    # Mandate a minimum of 16GB for the arc minimum and 72GB for the max (the server has 128GB, this optimizes assuming high VM pressure)
    extraModprobeConfig = "options zfs zfs_arc_min=20199768064 zfs_arc_max=77309411328";
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
    ];

    kernelPackages = pkgs.linuxKernel.packages.linux_6_18;
    kernelParams = [
      "quiet"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=auto"
    ];

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        editor = false;
      };

      timeout = 3;
    };
  };
}
