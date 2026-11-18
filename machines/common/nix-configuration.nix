{ ... }:

{
  config = {
    boot.loader = {
      limine.maxGenerations = 20;
      systemd-boot.configurationLimit = 20;
    };

    nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };

      settings.auto-optimise-store = true;
    };
  };
}
