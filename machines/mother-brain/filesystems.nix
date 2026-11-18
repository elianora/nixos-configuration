{ ... }:

{
  config.fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/defb6b7c-b3bc-4f85-b295-4b9c4f28c667";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/6E7A-EDEB";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    "/srv" = {
      device = "mother-brain-tank";
      fsType = "zfs";
    };

    "/srv/configuration" = {
      depends = [ "/srv" ];
      device = "mother-brain-tank/configuration";
      fsType = "zfs";
    };

    "/srv/media" = {
      depends = [ "/srv" ];
      device = "mother-brain-tank/media";
      fsType = "zfs";
    };

    "/srv/virtual-machines" = {
      depends = [ "/srv" ];
      device = "mother-brain-tank/virtual-machines";
      fsType = "zfs";
    };

    "/srv/www" = {
      depends = [ "/srv" ];
      device = "mother-brain-tank/www";
      fsType = "zfs";
    };

    "/var/lib/containers/storage" = {
      depends = [ "/srv" ];
      device = "mother-brain-tank/containers";
      fsType = "zfs";
    };
  };
}
