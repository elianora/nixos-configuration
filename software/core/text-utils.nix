{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.core.text-utils.enable = lib.mkEnableOption "Enable text utilities";
      config = lib.mkIf config.software.core.text-utils.enable {
        home.packages = with pkgs; [
          gawk
          gnused
        ];

        programs.ripgrep.enable = true;
      };
    })
  ];
}
