{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.messengers.halloy.enable = lib.mkEnableOption "Enable Halloy IRC client";
      config = lib.mkIf config.software.messengers.halloy.enable {
        assertions = [
          {
            assertion = config.software.desktop-environments.plasma.enable;
            message = "A desktop environment is required to enable Halloy IRC client";
          }
        ];

        programs.halloy = {
          enable = true;
          package = pkgs.callPackage ./build-from-rust.nix {};
        };
      };
    })
  ];
}
