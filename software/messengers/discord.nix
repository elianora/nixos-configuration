{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      options.software.messengers.discord.enable = lib.mkEnableOption "Enable Discord chat";
      config = lib.mkIf config.software.messengers.discord.enable {
        assertions = [
          {
            assertion = config.software.desktop-environments.plasma.enable;
            message = "A desktop environment is required to enable Discord";
          }
        ];

        programs.discord = {
          enable = true;
          package = (pkgs.discord.override {
            withTTS = true;
          });
        };
      };
    })
  ];
}
