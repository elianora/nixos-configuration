{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.development-tools.languages.nix.enable = lib.mkEnableOption "Enable Nix language support and tooling";
      config.home.packages = lib.optionals config.software.development-tools.languages.nix.enable (with pkgs; [
        nixd
        nixdoc
        nixfmt
      ]);
    })
  ];
}
