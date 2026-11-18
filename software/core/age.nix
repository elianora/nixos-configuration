{ pkgs, ... }:

{
  config.environment.systemPackages = with pkgs; [
    age
    ssh-to-age
  ];
}
