{ config, ... }:

{
  services.flatpak.enable = builtins.any (user:
    config.home-manager.users.${user}.software.office-and-notes.obsidian.enable ||
    config.home-manager.users.${user}.software.recording-and-streaming.open-deck.enable
  ) (builtins.attrNames config.home-manager.users);
}
