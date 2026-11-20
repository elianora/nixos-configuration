{ config, lib, pkgs, ... }:

{
  options.software.filesystems.zfs = {
    enable = lib.mkEnableOption "Enable ZFS filesystem support";
    host-id = lib.mkOption {
      description = ''
        The 32bit networking host ID of the system, which guarantees that the correct ZFS filesystem is mounted.
        Use `head -c4 /dev/urandom | od -A none -t x4` to generate this value.
      '';

      type = lib.types.str;
    };
  };

  config = lib.mkIf config.software.filesystems.zfs.enable {
    boot = {
      supportedFilesystems.zfs = true;
      zfs = {
        forceImportRoot = false;
        package = config.boot.kernelPackages.zfs_cachyos;
      };
    };

    environment.systemPackages = with pkgs; [
      zfs
    ];

    networking.hostId = config.software.filesystems.zfs.host-id;
    services.zfs.autoScrub = {
      enable = true;
      interval = "*-*-1,15 00:00";
    };

    systemd.services.zfs-mount.enable = false;
  };
}
