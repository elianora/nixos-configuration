{ ... }:

{
  imports = [
    ../common
    ./boot.nix
    ./filesystems.nix
    ./networking.nix
    ./platform.nix
  ];

  config = {
    localization = {
      locale = "en_US.UTF-8";
      timeZone = "America/New_York";
    };

    software = {
      cockpit.enable = true;
      filesystems.zfs = {
        enable = true;
        host-id = "f4681966";
      };

      networking.ssh.enable = true;
      virtualization.cpu-type = "amd";
    };

    system-type = "server";
  };
}
