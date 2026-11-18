{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.development-tools.languages.ruby.enable = lib.mkEnableOption "Enable Ruby language support";
      config.home.packages = lib.optional config.software.development-tools.languages.ruby.enable pkgs.ruby;
    })
  ];
}
