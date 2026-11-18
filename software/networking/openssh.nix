{ config, lib, ... }:

{
  options.software.networking.ssh.enable = lib.mkEnableOption "Enable OpenSSH server";
  config.services.openssh = lib.mkIf config.software.networking.ssh.enable {
    enable = true;
    openFirewall = true;
    settings = {
      AllowUsers = builtins.attrNames config.home-manager.users;
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      UseDns = true;
    };
  };
}
