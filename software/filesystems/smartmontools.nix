{ pkgs, ... }:

{
  config.environment.systemPackages = with pkgs; [
    smartmontools
  ];
}
