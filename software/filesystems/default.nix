{ pkgs, ... }:

{
  imports = [
    ./gparted.nix
    ./smartmontools.nix
    ./zfs.nix
  ];

  config.environment.systemPackages = with pkgs; [
    exfat
    ntfs3g
    sshfs
    usbutils
  ];
}
