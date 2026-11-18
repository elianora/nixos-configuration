{ lib, pkgs, ... }:

let
  winbox-updated = pkgs.callPackage ./build-from-zip.nix {
    pname = "winbox";
    version = "4.5";
    hash = "sha256-UZKBcInrkaxdA+3GhmGyYD74H4CYYnq0/ZQltsx1RqI=";
    metaCommon = {
      description = "Graphical configuration utility for RouterOS-based devices";
      homepage = "https://mikrotik.com";
      downloadPage = "https://mikrotik.com/download";
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      license = lib.licenses.unfree;
      mainProgram = "WinBox";
      maintainers = with lib.maintainers; [
        yrd
        savalet
        martinkontsek
      ];
    };
  };
in
{
  config.home-manager.sharedModules = [
    ({ config, lib, ... }: {
      options.software.networking.winbox.enable = lib.mkEnableOption "Enable WinBox (MikroTik management tool)";
      config = lib.mkIf config.software.networking.winbox.enable {
        assertions = [
          {
            assertion = config.software.desktop-environments.plasma.enable;
            message = "A desktop environment is required to enable WinBox";
          }
        ];

        home.packages = [
          winbox-updated
        ];
      };
    })
  ];
}
