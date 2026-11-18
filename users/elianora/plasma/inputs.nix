{ config, lib, ... }:

{
  config.programs.plasma.input = lib.mkIf config.software.desktop-environments.plasma.enable {
    keyboard.numlockOnStartup = "on";
    touchpads = [
      {
        disableWhileTyping = true;
        enable = true;
        leftHanded = false;
        middleButtonEmulation = false;
        name = "DELL098F:00 04F3:311C Touchpad";
        naturalScroll = true;
        pointerSpeed = 0;
        productId = "311c";
        tapToClick = false;
        vendorId = "04f3";
      }
    ];
  };
}
