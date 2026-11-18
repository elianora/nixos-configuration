{ ... }:

{
  config.fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/1fd701b8-1f7d-4729-aa95-c0c857bf4a9d";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/FBD8-4577";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
  };
}
