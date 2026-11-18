{ ... }:

{
  config.home-manager.sharedModules = [
    ({ config, lib, ... }: {
      options.software.core.starship.enable = lib.mkEnableOption "Enable starship";
      config.programs.starship = lib.mkIf config.software.core.starship.enable {
        enable = true;
        settings = {
          add_newline = false;
          aws.disabled = true;
          gcloud.disabled = true;
          line_break.disabled = true;
        };
      };
    })
  ];
}
