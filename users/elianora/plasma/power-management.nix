{ config, lib, ... }:

{
  config.programs.plasma.powerdevil = lib.mkIf config.software.desktop-environments.plasma.enable {
    AC = {
      powerButtonAction = "showLogoutScreen";
      autoSuspend.action = "nothing";
    };
  };
}
