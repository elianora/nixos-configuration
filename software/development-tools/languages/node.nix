{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.development-tools.languages.node.enable = lib.mkEnableOption "Enable Node.js language support and tooling";
      config.home.packages = lib.optional config.software.development-tools.languages.node.enable pkgs.nodejs_26;
    })
  ];
}
