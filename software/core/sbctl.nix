{ pkgs, ... }:

{
  config.environment.systemPackages = with pkgs; [
    sbctl
  ];
}
