{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.development-tools.languages.python.enable = lib.mkEnableOption "Enable Python language support and tooling";
      config.home.packages = lib.optional config.software.development-tools.languages.python.enable pkgs.python314;
    })
  ];
}
