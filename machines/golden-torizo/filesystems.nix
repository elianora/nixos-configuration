{ ... }:

{
  config.fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/4455075c-ec3a-468c-970b-988f41aefc73";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/CC83-B2D1";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
  };
}
