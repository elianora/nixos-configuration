{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.core.compression-utils.enable = lib.mkEnableOption "Enable compression utilities";
      config.home.packages = lib.optionals config.software.core.compression-utils.enable (with pkgs; [
        asar
        gnutar
        p7zip
        unzip
        xz
        zip
        zstd
      ]);
    })
  ];
}
