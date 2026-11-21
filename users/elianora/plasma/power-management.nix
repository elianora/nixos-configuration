{ config, lib, ... }:

{
  config.programs.plasma.powerdevil = lib.mkIf config.software.desktop-environments.plasma.enable {
    AC = {
      autoSuspend.action = "nothing";
      powerButtonAction = "showLogoutScreen";
      powerProfile = "performance";
      whenLaptopLidClosed = "sleep";
    };

    battery = {
      autoSuspend = {
        action = "sleep";
        idleTimeout = 900;
      };

      powerButtonAction = "showLogoutScreen";
      powerProfile = "balanced";
      whenLaptopLidClosed = "sleep";
    };

    batteryLevels = {
      lowLevel = 20;
      criticalAction = "shutDown";
      criticalLevel = 5;
    };

    general.pausePlayersOnSuspend = true;
    lowBattery = {
      autoSuspend = {
        action = "sleep";
        idleTimeout = 300;
      };

      powerButtonAction = "showLogoutScreen";
      powerProfile = "powerSaving";
      whenLaptopLidClosed = "sleep";
    };
  };
}
