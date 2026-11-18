{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.development-tools.languages.cpp.enable = lib.mkEnableOption "Enable C and C++ language support and tooling";
      config.home.packages = lib.optionals config.software.development-tools.languages.cpp.enable (with pkgs; [
        cmake
        gcc
        gnumake
      ]);
    })
  ];
}
